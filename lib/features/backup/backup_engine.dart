import 'dart:io';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import '../../core/db/database.dart';

class BackupEngine {
  final AppDatabase db;

  BackupEngine(this.db);

  /// Manual Backup Trigger
  Future<bool> backupNow(String targetDirectoryPath) async {
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd_HHmm').format(now);
    final backupFileName = 'arham_backup_$timestamp.db';
    final targetPath = '$targetDirectoryPath\\$backupFileName';

    // We use a unique ID for the log
    final backupId = 'bck_${now.millisecondsSinceEpoch}';

    try {
      final dbFolder = await _getAppDbDirectory();
      final sourceFile = File('${dbFolder.path}\\arham_autos.db');

      if (!await sourceFile.exists()) {
        throw Exception("Source database file not found.");
      }

      final sourceBytes = await sourceFile.length();

      // Perform the copy
      await sourceFile.copy(targetPath);

      // Log success
      await db
          .into(db.backupLog)
          .insert(
            BackupLogCompanion.insert(
              backupId: backupId,
              filePath: targetPath,
              sizeBytes: Value(sourceBytes),
              status: 'SUCCESS',
            ),
          );

      return true;
    } catch (e) {
      // Log failure
      await db
          .into(db.backupLog)
          .insert(
            BackupLogCompanion.insert(
              backupId: backupId,
              filePath: targetPath,
              status: 'FAILED',
            ),
          );
      return false;
    }
  }

  /// Calculates folder size and free space for display
  Future<Map<String, dynamic>> getBackupDirectoryStats(
    String targetDirectoryPath,
  ) async {
    final dir = Directory(targetDirectoryPath);
    if (!await dir.exists()) return {'folderSize': 0, 'freeSpace': 0};

    int totalSize = 0;
    try {
      await for (final file in dir.list(recursive: false)) {
        if (file is File && file.path.endsWith('.db')) {
          totalSize += await file.length();
        }
      }
    } catch (e) {
      // Ignored for now
    }

    // NOTE: In Windows, getting free disk space programmatically via pure Dart
    // requires ffi or specific packages. We will mock this or rely on a platform channel.
    // For now returning 0 for freeSpace.
    return {
      'folderSize': totalSize,
      'freeSpace': 0, // TODO: Implement using win32 or ffi
    };
  }

  Future<Directory> _getAppDbDirectory() async {
    final appData = Platform.environment['APPDATA'] ?? '';
    if (appData.isNotEmpty) {
      return Directory('$appData\\ArhamAutos');
    }
    return Directory('${Directory.current.path}\\ArhamAutos');
  }
}
