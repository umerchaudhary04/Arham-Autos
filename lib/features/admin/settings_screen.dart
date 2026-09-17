import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import '../../core/security/idle_lock_provider.dart';

final usersListProvider = FutureProvider<List<LocalUser>>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.usersDao.getAllUsers();
});

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final idleLockDuration = ref.watch(idleLockProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Admin Settings', style: Theme.of(context).textTheme.headlineMedium),
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
                          return DropdownMenuItem<int>(
                            value: val,
                            child: Text('$val'),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          if (newVal != null) {
                            ref.read(idleLockProvider.notifier).updateTimeout(newVal * 60);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Text('User Management', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];
                    return ListTile(
                      title: Text(u.username),
                      subtitle: Text('Role: ${u.role}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.key), onPressed: () {}),
                        ],
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
          ElevatedButton(
            onPressed: () {
              // Open Audit Log Viewer Modal
            },
            child: const Text('View System Audit Log'),
          )
        ],
      ),
    );
  }
}
