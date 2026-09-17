import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_provider.dart';
import '../../core/db/database.dart';

class LedgerTypeNotifier extends Notifier<String> {
  @override
  String build() => 'Customer';
  void setType(String type) => state = type;
}
final ledgerTypeProvider = NotifierProvider<LedgerTypeNotifier, String>(() => LedgerTypeNotifier());

final ledgerAccountsProvider = FutureProvider<List<AccountsLedgerData>>((ref) async {
  final type = ref.watch(ledgerTypeProvider);
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.ledgerDao.getAccountsByType(type);
});

class KhataLedgerScreen extends ConsumerWidget {
  const KhataLedgerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledgerAsync = ref.watch(ledgerAccountsProvider);
    final selectedType = ref.watch(ledgerTypeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Khata Ledger', style: Theme.of(context).textTheme.headlineMedium),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Customer', label: Text('Customers')),
                  ButtonSegment(value: 'Supplier', label: Text('Suppliers')),
                ],
                selected: {selectedType},
                onSelectionChanged: (Set<String> newSelection) {
                  ref.read(ledgerTypeProvider.notifier).setType(newSelection.first);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ledgerAsync.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Center(child: Text('No $selectedType accounts found.'));
                }
                return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final acc = accounts[index];
                    final limit = acc.creditLimit ?? 100000.0; // Mock limit if null
                    final progress = acc.currentBalance / limit;
                    
                    return Card(
                      child: ListTile(
                        title: Text(acc.accountName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Balance: ₨ ${acc.currentBalance} / Limit: ₨ $limit'),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              color: progress > 0.9 ? Colors.red : (progress > 0.7 ? Colors.orange : Colors.green),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Structural mock for viewing details
                          },
                          child: const Text('View Ledger'),
                        ),
                      ),
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
