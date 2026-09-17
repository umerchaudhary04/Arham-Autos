import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import 'package:drift/drift.dart' as drift;

class LegacyImportService {
  final AppDatabase db;
  final String userId;

  LegacyImportService(this.db, this.userId);

  /// 1. Extract .accdb to JSON using PowerShell script
  Future<Map<String, dynamic>> extractDatabase(String dbPath) async {
    final tempDir = await Directory.systemTemp.createTemp('arham_autos_import');
    final outPath = '${tempDir.path}\\extracted.json';

    // We assume scripts/extract_accdb.ps1 is bundled or available in current working directory
    final scriptPath = 'scripts\\extract_accdb.ps1';

    final result = await Process.run('powershell', [
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      scriptPath,
      '-DbPath',
      dbPath,
      '-OutputPath',
      outPath,
    ]);

    if (result.exitCode != 0) {
      throw Exception('Extraction failed: ${result.stderr}');
    }

    final jsonFile = File(outPath);
    if (!await jsonFile.exists()) {
      throw Exception('Extraction JSON file not found.');
    }

    final content = await jsonFile.readAsString();
    await jsonFile.delete(); // Cleanup

    return jsonDecode(content) as Map<String, dynamic>;
  }

  /// 2-3. Field Mapping & Validation Skip
  /// Validates mapped parts and accounts. Skips invalid records instead of aborting.
  Map<String, dynamic> validateAndMap(Map<String, dynamic> rawData) {
    // Example legacy tables: 'Items', 'Customers'
    final validParts = <Map<String, dynamic>>[];
    final skippedRecords = <Map<String, dynamic>>[];

    if (rawData.containsKey('Items')) {
      for (var item in rawData['Items']) {
        if (item['PartName'] == null ||
            item['PartName'].toString().trim().isEmpty) {
          skippedRecords.add({
            'table': 'Items',
            'reason': 'Missing PartName',
            'data': item,
          });
          continue;
        }
        validParts.add({
          'partId': const Uuid().v4(),
          'partName': item['PartName'],
          'oemNumber': item['OEM']?.toString(),
          'model': item['Model']?.toString(),
          'rackLocation': item['Rack']?.toString(),
        });
      }
    }

    return {'validParts': validParts, 'skippedRecords': skippedRecords};
  }

  /// 4-6. Final Commit with manual opening stock costs
  Future<void> commitImport(
    List<Map<String, dynamic>> partsWithStock,
    List<Map<String, dynamic>> skippedRecords,
  ) async {
    final migrationId = const Uuid().v4();
    int importedCount = 0;

    await db.transaction(() async {
      for (var part in partsWithStock) {
        final partId = part['partId'];

        // Insert AutoPart
        await db
            .into(db.autoParts)
            .insert(
              AutoPartsCompanion.insert(
                partId: partId,
                partName: part['partName'],
                oemNumber: drift.Value(part['oemNumber']),
                model: drift.Value(part['model']),
                rackLocation: drift.Value(part['rackLocation']),
              ),
            );

        // Insert FifoBatch if opening stock is provided
        if (part['openingQuantity'] != null && part['openingQuantity'] > 0) {
          await db
              .into(db.fifoInventoryBatches)
              .insert(
                FifoInventoryBatchesCompanion.insert(
                  batchId: const Uuid().v4(),
                  partId: partId,
                  originalQuantity: part['openingQuantity'],
                  remainingQuantity: part['openingQuantity'],
                  unitLandedCost: part['openingCost'] ?? 0.0,
                ),
              );
        }
        importedCount++;
      }

      // Write MigrationLog
      await db
          .into(db.migrationLog)
          .insert(
            MigrationLogCompanion.insert(
              migrationId: migrationId,
              sourceFile: 'Legacy Import Wizard',
              recordsImported: drift.Value(importedCount),
              recordsFlagged: drift.Value(skippedRecords.length),
              performedBy: drift.Value(userId),
            ),
          );
    });
  }
}

final legacyImportServiceProvider = Provider<LegacyImportService?>((ref) {
  final db = ref.watch(databaseProvider);
  final user = ref.watch(authProvider).user;
  if (db == null || user == null) return null;
  return LegacyImportService(db, user.id);
});
