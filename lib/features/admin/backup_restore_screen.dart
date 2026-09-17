import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'backup_service.dart';
import '../../core/security/auth_provider.dart';
import '../../core/security/encryption_key_store.dart';

final backupServiceProvider = Provider((ref) => BackupService());

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() =>
      _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _isProcessing = false;
  String _status = '';

  Map<String, dynamic>? _backupStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final svc = ref.read(backupServiceProvider);
    final stats = await svc.getBackupStats();
    if (mounted) {
      setState(() {
        _backupStats = stats;
      });
    }
  }

  Future<void> _backupNow() async {
    setState(() {
      _isProcessing = true;
      _status = 'Backing up...';
    });
    try {
      final user = ref.read(authProvider).user!;
      final path = await ref.read(backupServiceProvider).createBackup(user.id);
      _status = 'Backup successful: $path';
      await _loadStats();
    } catch (e) {
      _status = 'Backup failed: $e';
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _restoreWizard() async {
    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['db', 'sqlite'],
    );

    if (result != null && result.path != null) {
      final path = result.path!;

      // Confirm highly destructive action
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('DANGER: Restore Database'),
          content: Text(
            'Are you sure you want to restore from:\n$path\n\nThis will OVERWRITE the current database. A safety backup will be taken first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'PROCEED',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

      if (confirm == true) {
        setState(() {
          _isProcessing = true;
          _status = 'Restoring database...';
        });

        try {
          final user = ref.read(authProvider).user!;
          final keyStore = ref.read(encryptionKeyStoreProvider);
          final key = await keyStore.loadKey();
          if (key == null) throw Exception('Cannot load encryption key.');

          await ref
              .read(backupServiceProvider)
              .restoreDatabase(path, user.id, key);

          if (mounted) {
            _status = 'Restore complete! Please restart the app.';
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                title: const Text('Restore Successful'),
                content: const Text(
                  'The database has been restored. The application must now restart.',
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () => exit(0),
                    child: const Text('Exit App'),
                  ),
                ],
              ),
            );
          }
        } catch (e) {
          _status = 'Restore failed: $e';
        } finally {
          if (mounted) setState(() => _isProcessing = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backup & Restore')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isProcessing) const LinearProgressIndicator(),
            if (_status.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _status,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

            // Backup Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Backup Data',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Divider(),
                    if (_backupStats != null) ...[
                      Text(
                        'Last Backup: ${_backupStats!['lastBackupTime'] ?? 'Never'}',
                      ),
                      Text(
                        'Backup Folder Size: ${_backupStats!['folderSizeMB']} MB',
                      ),
                      Text(
                        'Available Disk Space: ${_backupStats!['freeSpaceGB']} GB',
                      ),
                    ] else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.backup),
                      label: const Text('Backup Now'),
                      onPressed: _isProcessing ? null : _backupNow,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Restore Wizard
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restore Wizard',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.red),
                    ),
                    const Text(
                      'WARNING: This will replace the entire current database.',
                      style: TextStyle(color: Colors.red),
                    ),
                    const Divider(),
                    const Text(
                      '1. A PRAGMA integrity_check will be run on the selected file.\n2. A safety backup of your current database will automatically be taken.\n3. The application will close after restoration.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.restore),
                      label: const Text('Select Backup File & Restore'),
                      onPressed: _isProcessing ? null : _restoreWizard,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
