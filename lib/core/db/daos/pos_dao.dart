import 'package:drift/drift.dart';
import '../database.dart';
import 'package:uuid/uuid.dart';

part 'pos_dao.g.dart';

@DriftAccessor(
  tables: [SalesInvoices, InvoiceItems, FifoInventoryBatches, AccountsLedger],
)
class PosDao extends DatabaseAccessor<AppDatabase> with _$PosDaoMixin {
  PosDao(AppDatabase db) : super(db);

  // Atomic database transaction sequence: DB write first (FIFO deduction, ledger update, invoice creation)
  Future<String> processSale({
    required String userId,
    required String? customerId,
    required List<CartItem> items,
    required double discount,
    required double totalAmount,
    required double finalAmount,
  }) async {
    return transaction(() async {
      final invoiceId = const Uuid().v4();

      // 1. Create Invoice
      await into(salesInvoices).insert(
        SalesInvoicesCompanion.insert(
          invoiceId: invoiceId,
          customerId: Value(customerId),
          totalAmount: totalAmount,
          discount: Value(discount),
          finalAmount: finalAmount,
          createdBy: userId,
        ),
      );

      // 2. FIFO Deduction & Invoice Items Creation
      for (final item in items) {
        int qtyRemainingToDeduct = item.quantity;

        // Fetch batches ordered by receivedAt (FIFO)
        final batches =
            await (select(fifoInventoryBatches)
                  ..where(
                    (b) =>
                        b.partId.equals(item.partId) &
                        b.remainingQuantity.isBiggerThanValue(0),
                  )
                  ..orderBy([
                    (b) => OrderingTerm(
                      expression: b.receivedAt,
                      mode: OrderingMode.asc,
                    ),
                  ]))
                .get();

        for (final batch in batches) {
          if (qtyRemainingToDeduct <= 0) break;

          final deductQty = qtyRemainingToDeduct <= batch.remainingQuantity
              ? qtyRemainingToDeduct
              : batch.remainingQuantity;
          qtyRemainingToDeduct -= deductQty;

          // Deduct from batch
          await update(fifoInventoryBatches).replace(
            batch.copyWith(
              remainingQuantity: batch.remainingQuantity - deductQty,
            ),
          );

          // Record invoice item
          await into(invoiceItems).insert(
            InvoiceItemsCompanion.insert(
              itemId: const Uuid().v4(),
              invoiceId: invoiceId,
              partId: item.partId,
              batchId: batch.batchId,
              quantity: deductQty,
              unitPrice: item.unitPrice,
              unitCogs: batch.unitLandedCost, // Exact COGS calculation
            ),
          );
        }

        if (qtyRemainingToDeduct > 0) {
          throw Exception(
            "Strict stock over-sell block: Not enough stock for part ${item.partId}. Missing: $qtyRemainingToDeduct",
          );
        }
      }

      // 3. Ledger Update (if on credit)
      if (customerId != null) {
        final account = await (select(
          accountsLedger,
        )..where((a) => a.accountId.equals(customerId))).getSingle();
        final newBalance = account.currentBalance + finalAmount;

        // Ensure credit limit is respected (UI can bypass via Pin Modal, but DB validates if limit exists and is strictly enforced unless passed down)
        // Here we just update, bypass logic handles pin beforehand.
        await update(
          accountsLedger,
        ).replace(account.copyWith(currentBalance: newBalance));
      }

      return invoiceId;
    });
  }
}

class CartItem {
  final String partId;
  final int quantity;
  final double unitPrice;

  CartItem({
    required this.partId,
    required this.quantity,
    required this.unitPrice,
  });
}
