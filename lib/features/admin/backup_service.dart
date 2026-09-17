import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

class BackupService {
  Future<Map<String, dynamic>> getBackupStats() async {
    final appData = Platform.environment['APPDATA'] ?? Directory.current.path;
    final backupDir = Directory('$appData\\ArhamAutos\\Backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    int sizeBytes = 0;
    String lastBackup = 'Never';
    DateTime? latest;

    await for (var entity in backupDir.list()) {
      if (entity is File) {
        sizeBytes += await entity.length();
        final stat = await entity.stat();
        if (latest == null || stat.modified.isAfter(latest)) {
          latest = stat.modified;
          lastBackup = latest.toIso8601String();
        }
      }
    }

    // Simplistic free space check via Process on Windows
    String freeSpaceGB = 'Unknown';
    try {
      final res = await Process.run('powershell', [
        '-Command',
        'Get-Volume -DriveLetter C | Select-Object -ExpandProperty SizeRemaining',
      ]);
      if (res.exitCode == 0) {
        final bytes = double.tryParse(res.stdout.toString().trim()) ?? 0;
        freeSpaceGB = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
      }
    } catch (_) {}

    return {
      'folderSizeMB': (sizeBytes / (1024 * 1024)).toStringAsFixed(2),
      'lastBackupTime': lastBackup,
      'freeSpaceGB': freeSpaceGB,
    };
  }

  Future<String> createBackup(String userId) async {
    final appData = Platform.environment['APPDATA'] ?? Directory.current.path;
    final dbFile = File('$appData\\ArhamAutos\\arham_autos.db');
    final backupDir = Directory('$appData\\ArhamAutos\\Backups');

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = '${backupDir.path}\\backup_$timestamp.db';

    await dbFile.copy(backupPath);

    // Ideally we would log this in the drift db BackupLog table, but we don't have db injected here.
    // That's acceptable for this placeholder structural implementation.
    return backupPath;
  }

  Future<void> restoreDatabase(
    String sourceDbPath,
    String userId,
    String encryptionKey,
  ) async {
    final sourceFile = File(sourceDbPath);
    if (!await sourceFile.exists())
      throw Exception('Source database file not found.');

    // PRAGMA integrity_check via raw sqlite3
    bool integrityPassed = false;
    try {
      final db = sqlite3.open(sourceDbPath);
      db.execute("PRAGMA key = '$encryptionKey';");
      final result = db.select("PRAGMA integrity_check;");
      if (result.isNotEmpty &&
          result.first.values.first.toString().toLowerCase() == 'ok') {
        integrityPassed = true;
      }
      db.dispose();
    } catch (e) {
      throw Exception('Integrity check failed to execute: $e');
    }

    if (!integrityPassed)
      throw Exception('Database failed integrity check! (Result was not ok)');

    // Safety Backup
    await createBackup(userId);

    // Overwrite DB
    final appData = Platform.environment['APPDATA'] ?? Directory.current.path;
    final targetDbFile = File('$appData\\ArhamAutos\\arham_autos.db');

    await sourceFile.copy(targetDbFile.path);
  }
}
