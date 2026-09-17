import 'package:drift/drift.dart';
import '../database.dart';

part 'parts_dao.g.dart';

@DriftAccessor(tables: [AutoParts, FifoInventoryBatches, AuditLog])
class PartsDao extends DatabaseAccessor<AppDatabase> with _$PartsDaoMixin {
  PartsDao(AppDatabase db) : super(db);

  // Multi-attribute search (Part Name, OEM #, Model, Rack)
  Future<List<AutoPart>> searchParts(String query) {
    if (query.isEmpty) return select(autoParts).get();
    
    final q = '%$query%';
    return (select(autoParts)
      ..where((p) =>
          p.partName.like(q) |
          p.oemNumber.like(q) |
          p.model.like(q) |
          p.rackLocation.like(q)))
        .get();
  }

  // Calculate total remaining quantity across all batches
  Future<int> getStockLevel(String partId) async {
    final query = select(fifoInventoryBatches)..where((b) => b.partId.equals(partId));
    final batches = await query.get();
    return batches.fold<int>(0, (sum, batch) => sum + batch.remainingQuantity);
  }

  // Manual stock adjustment (Admin/Manager restricted - handled in UI layer)
  Future<void> manualStockAdjustment(String partId, String batchId, int qtyChange, String reason, String userId) async {
    return transaction(() async {
      // Fetch batch
      final batch = await (select(fifoInventoryBatches)..where((b) => b.batchId.equals(batchId))).getSingle();
      
      // Update quantity
      final newQty = batch.remainingQuantity + qtyChange;
      await update(fifoInventoryBatches).replace(batch.copyWith(remainingQuantity: newQty));
      
      // Log audit
      await into(auditLog).insert(AuditLogCompanion.insert(
        userId: userId,
        actionType: 'STOCK_ADJUSTMENT',
        targetTable: const Value('fifo_inventory_batches'),
        recordId: Value(batchId),
        oldValue: Value(batch.remainingQuantity.toString()),
        newValue: Value(newQty.toString()),
      ));
    });
  }
}
