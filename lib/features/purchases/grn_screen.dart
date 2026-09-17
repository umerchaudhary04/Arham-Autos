import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import 'package:drift/drift.dart' as drift;

class GrnScreen extends ConsumerStatefulWidget {
  const GrnScreen({super.key});

  @override
  ConsumerState<GrnScreen> createState() => _GrnScreenState();
}

class _GrnScreenState extends ConsumerState<GrnScreen> {
  String? _selectedSupplierId;
  final List<Map<String, dynamic>> _lineItems = [];
  bool _isLoading = false;
  List<AccountsLedgerData> _suppliers = [];
  List<AutoPart> _parts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    if (db == null) return;
    
    final ledgers = await db.select(db.accountsLedger).get();
    final suppliers = ledgers.where((l) => l.accountType == 'Supplier').toList();
    final parts = await db.select(db.autoParts).get();

    setState(() {
      _suppliers = suppliers;
      _parts = parts;
    });
  }

  void _addLineItem() {
    setState(() {
      _lineItems.add({
        'partId': null,
        'qty': 0,
        'cost': 0.0,
      });
    });
  }

  Future<void> _commitGrn() async {
    if (_selectedSupplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a supplier first')));
      return;
    }
    
    // Validate
    for (var item in _lineItems) {
      if (item['partId'] == null || item['qty'] <= 0 || item['cost'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid line item data')));
        return;
      }
    }
    
    setState(() => _isLoading = true);
    
    try {
      final db = ref.read(databaseProvider)!;
      final userId = ref.read(authProvider).user!.id;
      
      await db.transaction(() async {
        for (var item in _lineItems) {
          final batchId = const Uuid().v4();
          await db.into(db.fifoInventoryBatches).insert(
            FifoInventoryBatchesCompanion.insert(
              batchId: batchId,
              partId: item['partId'],
              originalQuantity: item['qty'],
              remainingQuantity: item['qty'],
              unitLandedCost: item['cost'],
              supplierId: drift.Value(_selectedSupplierId),
            )
          );
        }
        
        // Audit log
        await db.into(db.auditLog).insert(
          AuditLogCompanion.insert(
            userId: userId,
            actionType: 'GRN_ENTRY',
            targetTable: const drift.Value('fifo_inventory_batches'),
            newValue: drift.Value('Supplier: $_selectedSupplierId, Items: ${_lineItems.length}'),
          )
        );
      });
      
      setState(() {
        _lineItems.clear();
        _selectedSupplierId = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('GRN committed successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Purchases & GRN (Goods Receipt Note)',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Supplier Details', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSupplierId,
                    decoration: const InputDecoration(labelText: 'Select Supplier'),
                    items: _suppliers.map((s) => DropdownMenuItem(value: s.accountId, child: Text(s.accountName))).toList(),
                    onChanged: (v) => setState(() => _selectedSupplierId = v),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Line Items', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                onPressed: _addLineItem,
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: ListView.builder(
              itemCount: _lineItems.length,
              itemBuilder: (ctx, index) {
                final item = _lineItems[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: item['partId'],
                            decoration: const InputDecoration(labelText: 'Part'),
                            items: _parts.map((p) => DropdownMenuItem(value: p.partId, child: Text(p.partName))).toList(),
                            onChanged: (v) => setState(() => item['partId'] = v),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Qty'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => item['qty'] = int.tryParse(v) ?? 0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(labelText: 'Unit Landed Cost'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => item['cost'] = double.tryParse(v) ?? 0.0,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => _lineItems.removeAt(index)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
            onPressed: _isLoading ? null : _commitGrn,
            child: _isLoading ? const CircularProgressIndicator() : const Text('Confirm & Commit GRN'),
          ),
        ],
      ),
    );
  }
}
