import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import 'returns_service.dart';

final returnsServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return ReturnsService(db!);
});

final pendingClaimsProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(returnsServiceProvider).getPendingClaims();
});

class ReturnsClaimsScreen extends ConsumerStatefulWidget {
  const ReturnsClaimsScreen({super.key});

  @override
  ConsumerState<ReturnsClaimsScreen> createState() =>
      _ReturnsClaimsScreenState();
}

class _ReturnsClaimsScreenState extends ConsumerState<ReturnsClaimsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isManager = user?.role == 'Admin' || user?.role == 'Manager';

    return DefaultTabController(
      length: isManager ? 3 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Returns & Claims'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Customer Return'),
              if (isManager) const Tab(text: 'Pending Approvals'),
              if (isManager) const Tab(text: 'Supplier Warranty'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const CustomerReturnTab(),
            if (isManager) const PendingApprovalsTab(),
            if (isManager) const SupplierWarrantyTab(),
          ],
        ),
      ),
    );
  }
}

class CustomerReturnTab extends ConsumerStatefulWidget {
  const CustomerReturnTab({super.key});
  @override
  ConsumerState<CustomerReturnTab> createState() => _CustomerReturnTabState();
}

class _CustomerReturnTabState extends ConsumerState<CustomerReturnTab> {
  final _invoiceCtrl = TextEditingController();
  SalesInvoice? _invoice;
  List<InvoiceItem> _items = [];
  final Map<String, int> _returnQtys = {};

  void _lookupInvoice() async {
    final db = ref.read(databaseProvider)!;
    final invId = _invoiceCtrl.text.trim();
    if (invId.isEmpty) return;

    final invoice = await (db.select(
      db.salesInvoices,
    )..where((i) => i.invoiceId.equals(invId))).getSingleOrNull();
    if (invoice != null) {
      final items = await (db.select(
        db.invoiceItems,
      )..where((i) => i.invoiceId.equals(invId))).get();
      setState(() {
        _invoice = invoice;
        _items = items;
        _returnQtys.clear();
      });
    } else {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invoice not found')));
    }
  }

  void _submit() async {
    final itemsToReturn = <Map<String, dynamic>>[];
    for (var item in _items) {
      final qty = _returnQtys[item.itemId] ?? 0;
      if (qty > 0) {
        itemsToReturn.add({'itemId': item.itemId, 'qty': qty});
      }
    }
    if (itemsToReturn.isEmpty) return;

    final user = ref.read(authProvider).user!;
    await ref
        .read(returnsServiceProvider)
        .submitReturnClaim(
          invoiceId: _invoice!.invoiceId,
          userId: user.id,
          itemsReturned: itemsToReturn,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Return claim submitted for approval')),
      );
      setState(() {
        _invoice = null;
        _items = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _invoiceCtrl,
                  decoration: const InputDecoration(labelText: 'Invoice ID'),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _lookupInvoice,
                child: const Text('Lookup'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_invoice != null) ...[
            Text(
              'Invoice: ${_invoice!.invoiceId} | Total: \$${_invoice!.finalAmount}',
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (ctx, i) {
                  final item = _items[i];
                  final currentQty = _returnQtys[item.itemId] ?? 0;
                  return ListTile(
                    title: Text('Part: ${item.partId} - Qty: ${item.quantity}'),
                    subtitle: Text('Unit Price: \$${item.unitPrice}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: currentQty > 0
                              ? () => setState(
                                  () =>
                                      _returnQtys[item.itemId] = currentQty - 1,
                                )
                              : null,
                        ),
                        Text('$currentQty'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: currentQty < item.quantity
                              ? () => setState(
                                  () =>
                                      _returnQtys[item.itemId] = currentQty + 1,
                                )
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit Return Request'),
            ),
          ],
        ],
      ),
    );
  }
}

class PendingApprovalsTab extends ConsumerWidget {
  const PendingApprovalsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimsAsync = ref.watch(pendingClaimsProvider);

    return claimsAsync.when(
      data: (claims) {
        if (claims.isEmpty)
          return const Center(child: Text('No pending claims'));
        return ListView.builder(
          itemCount: claims.length,
          itemBuilder: (ctx, i) {
            final c = claims[i];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  'Claim: ${c.claim.claimId} (Inv: ${c.claim.referenceInvoiceId})',
                ),
                subtitle: Text('Items: ${c.items.length}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(returnsServiceProvider)
                            .rejectReturnClaim(
                              c.claim.claimId,
                              ref.read(authProvider).user!.id,
                            );
                        ref.invalidate(pendingClaimsProvider);
                      },
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Prompt for refund method
                        final method = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Select Refund Method'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Cash'),
                                  onTap: () => Navigator.pop(context, 'Cash'),
                                ),
                                ListTile(
                                  title: const Text('Khata Credit'),
                                  onTap: () =>
                                      Navigator.pop(context, 'Khata Credit'),
                                ),
                              ],
                            ),
                          ),
                        );
                        if (method != null) {
                          await ref
                              .read(returnsServiceProvider)
                              .approveReturnClaim(
                                claimId: c.claim.claimId,
                                adminUserId: ref.read(authProvider).user!.id,
                                refundMethod: method,
                              );
                          ref.invalidate(pendingClaimsProvider);
                        }
                      },
                      child: const Text('Approve'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}

class SupplierWarrantyTab extends StatelessWidget {
  const SupplierWarrantyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Supplier Warranty Claim Form\n(Admin/Manager Only)'),
    );
  }
}
