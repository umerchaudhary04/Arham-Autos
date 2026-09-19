import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import '../../core/security/idle_lock_provider.dart';
import '../../main.dart'; // for localeProvider
import 'package:uuid/uuid.dart';

final usersListProvider = FutureProvider<List<LocalUser>>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.usersDao.getAllUsers();
});

final auditLogProvider = FutureProvider<List<AuditLogData>>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return (db.select(db.auditLog)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
});

final areasListProvider = FutureProvider<List<Area>>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.select(db.areas).get();
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  void _showAddUserDialog() {
    final usernameCtrl = TextEditingController();
    final fullnameCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final pinCtrl = TextEditingController();
    String selectedRole = 'Operator';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Add New User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Username')),
                    TextField(controller: fullnameCtrl, decoration: const InputDecoration(labelText: 'Full Name')),
                    TextField(controller: passwordCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                    TextField(controller: pinCtrl, decoration: const InputDecoration(labelText: 'PIN (4 digits)'), obscureText: true),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                        DropdownMenuItem(value: 'Manager', child: Text('Manager')),
                        DropdownMenuItem(value: 'Operator', child: Text('Operator')),
                      ],
                      onChanged: (v) {
                        if (v != null) setStateDialog(() => selectedRole = v);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    if (usernameCtrl.text.isEmpty || fullnameCtrl.text.isEmpty || passwordCtrl.text.isEmpty || pinCtrl.text.isEmpty) return;
                    
                    final db = ref.read(databaseProvider)!;
                    await db.into(db.localUsers).insert(LocalUsersCompanion.insert(
                      id: const Uuid().v4(),
                      fullName: fullnameCtrl.text,
                      username: usernameCtrl.text,
                      // For now, storing plain text in place of hash for structural mockup
                      passwordHash: passwordCtrl.text, 
                      pinHash: pinCtrl.text,
                      role: selectedRole,
                    ));
                    ref.invalidate(usersListProvider);
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save User'),
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _showAuditLog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: Container(
            width: 800,
            height: 600,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Audit Logs', style: Theme.of(context).textTheme.headlineSmall),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final logsAsync = ref.watch(auditLogProvider);
                      return logsAsync.when(
                        data: (logs) {
                          return ListView.builder(
                            itemCount: logs.length,
                            itemBuilder: (ctx, i) {
                              final log = logs[i];
                              return ListTile(
                                title: Text('${log.actionType} - ${log.targetTable ?? ''}'),
                                subtitle: Text('${log.createdAt} | User: ${log.userId} | ${log.newValue ?? ''}'),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, st) => Center(child: Text('Error: $e')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showAddAreaDialog() {
    final nameCtrl = TextEditingController();
    final cityCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add New Area'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Area Name')),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty) return;
                
                final db = ref.read(databaseProvider)!;
                await db.into(db.areas).insert(AreasCompanion.insert(
                  areaId: const Uuid().v4(),
                  areaName: nameCtrl.text,
                  city: drift.Value(cityCtrl.text),
                ));
                ref.invalidate(areasListProvider);
                Navigator.pop(ctx);
              },
              child: const Text('Save Area'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final idleLockDuration = ref.watch(idleLockProvider);
    final currentLocale = ref.watch(localeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Admin Settings', style: Theme.of(context).textTheme.headlineMedium),
              ElevatedButton.icon(
                icon: const Icon(Icons.language),
                label: Text('Language: ${currentLocale.languageCode == 'en' ? 'English' : 'Urdu'}'),
                onPressed: () async {
                  final newLocale = currentLocale.languageCode == 'en' ? const Locale('ur') : const Locale('en');
                  ref.read(localeProvider.notifier).setLocale(newLocale);
                  
                  // Update DB for current user so preference is saved
                  final user = ref.read(authProvider).user;
                  if (user != null) {
                    final db = ref.read(databaseProvider)!;
                    await db.update(db.localUsers).replace(
                      user.copyWith(preferredLanguage: newLocale.languageCode)
                    );
                    ref.read(authProvider.notifier).updateUserLanguage(newLocale.languageCode);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Security Configuration', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Idle Auto-Lock Timeout (minutes):'),
                      DropdownButton<int>(
                        value: (idleLockDuration ~/ 60),
                        items: [1, 5, 15, 30, 60].map((int val) {
                          return DropdownMenuItem<int>(value: val, child: Text('$val'));
                        }).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) ref.read(idleLockProvider.notifier).updateTimeout(newVal * 60);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Area Management', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.map),
                label: const Text('Add Area'),
                onPressed: _showAddAreaDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ref.watch(areasListProvider).when(
              data: (areas) {
                if (areas.isEmpty) return const Center(child: Text('No areas defined.'));
                return ListView.builder(
                  itemCount: areas.length,
                  itemBuilder: (context, index) {
                    final area = areas[index];
                    return Card(
                      child: ListTile(
                        title: Text(area.areaName),
                        subtitle: Text(area.city ?? ''),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User Management', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Add User'),
                onPressed: _showAddUserDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];
                    return Card(
                      child: ListTile(
                        title: Text(u.username),
                        subtitle: Text('Role: ${u.role} | Name: ${u.fullName}'),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),

          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.list_alt),
            onPressed: _showAuditLog,
            label: const Text('View System Audit Log'),
          ),
        ],
      ),
    );
  }
}
