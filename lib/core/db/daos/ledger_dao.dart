import 'package:drift/drift.dart';
import '../database.dart';
import 'package:uuid/uuid.dart';

part 'ledger_dao.g.dart';

@DriftAccessor(tables: [AccountsLedger, FifoInventoryBatches])
class LedgerDao extends DatabaseAccessor<AppDatabase> with _$LedgerDaoMixin {
  LedgerDao(AppDatabase db) : super(db);

  Future<List<AccountsLedgerData>> getAccountsByType(String type) {
    return (select(accountsLedger)..where((a) => a.accountType.equals(type))).get();
  }

  // GRN Flow: Enter landed costs per line item to generate new FIFO batches
  Future<void> receiveGoods(String supplierId, List<GrnItem> items, double totalCost) async {
    return transaction(() async {
      for (final item in items) {
        await into(fifoInventoryBatches).insert(FifoInventoryBatchesCompanion.insert(
          batchId: const Uuid().v4(),
          partId: item.partId,
          originalQuantity: item.quantity,
          remainingQuantity: item.quantity,
          unitLandedCost: item.landedCost,
          supplierId: Value(supplierId),
        ));
      }

      // Update supplier ledger (credit supplier for goods received)
      final account = await (select(accountsLedger)..where((a) => a.accountId.equals(supplierId))).getSingle();
      await update(accountsLedger).replace(
        account.copyWith(currentBalance: account.currentBalance + totalCost)
      );
    });
  }
}

class GrnItem {
  final String partId;
  final int quantity;
  final double landedCost;

  GrnItem({required this.partId, required this.quantity, required this.landedCost});
}
