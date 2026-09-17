import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/admin_pin_modal.dart';
import '../../core/security/auth_provider.dart';
import '../../core/db/database.dart';

class PartsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}
final partsSearchQueryProvider = NotifierProvider<PartsSearchQueryNotifier, String>(() => PartsSearchQueryNotifier());

final partsListProvider = FutureProvider<List<AutoPart>>((ref) async {
  final query = ref.watch(partsSearchQueryProvider);
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.partsDao.searchParts(query);
});

class PartsCatalogScreen extends ConsumerWidget {
  const PartsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(partsListProvider);
    final user = ref.watch(authProvider).user;
    final isManager = user?.role == 'Manager' || user?.role == 'Admin';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Parts Catalog & Inventory', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search by Part Name, OEM #, Model, or Rack',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (val) {
              ref.read(partsSearchQueryProvider.notifier).setQuery(val);
            },
          ),
          const SizedBox(height: 16),

          Expanded(
            child: partsAsync.when(
              data: (parts) {
                if (parts.isEmpty) {
                  return const Center(child: Text('No parts found.'));
                }
                return ListView.builder(
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final part = parts[index];
                    return ListTile(
                      title: Text(part.partName),
                      subtitle: Text('OEM: ${part.oemNumber ?? "N/A"} | Model: ${part.model ?? "N/A"} | Rack: ${part.rackLocation ?? "N/A"}'),
                      trailing: isManager ? ElevatedButton(
                        onPressed: () async {
                          final auth = await AdminPinModal.show(context, 'Manual Stock Adjustment for ${part.partName}');
                          if (!context.mounted) return;
                          if (auth) {
                            // In real impl, open stock adjustment modal to specify batch and qty
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authorized. (Structural Mock)')));
                          }
                        },
                        child: const Text('Adjust Stock'),
                      ) : null,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          )
        ],
      ),
    );
  }
}
