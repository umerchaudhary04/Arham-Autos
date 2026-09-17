import 'dart:convert';
import 'package:drift/drift.dart';
import '../../core/db/database.dart';
import 'package:uuid/uuid.dart';

class ReturnsService {
  final AppDatabase db;
  ReturnsService(this.db);

  // Submit a customer return claim
  Future<void> submitReturnClaim({
    required String invoiceId,
    required String userId,
    required List<Map<String, dynamic>> itemsReturned,
  }) async {
    final claimId = const Uuid().v4();

    await db.transaction(() async {
      // Create the claim record
      await db
          .into(db.returnsClaims)
          .insert(
            ReturnsClaimsCompanion.insert(
              claimId: claimId,
              claimType: 'CUSTOMER_RETURN',
              referenceInvoiceId: Value(invoiceId),
              initiatedBy: userId,
              status: const Value('PENDING_APPROVAL'),
            ),
          );

      // Store the items payload in audit log to avoid schema change
      await db
          .into(db.auditLog)
          .insert(
            AuditLogCompanion.insert(
              userId: userId,
              actionType: 'RETURN_CLAIM_ITEMS',
              targetTable: const Value('returns_claims'),
              recordId: Value(claimId),
              newValue: Value(
                jsonEncode(itemsReturned),
              ), // itemsReturned: [{itemId, qty, reason}]
            ),
          );
    });
  }

  // Get pending claims
  Future<List<ReturnClaimWithItems>> getPendingClaims() async {
    final claims = await (db.select(
      db.returnsClaims,
    )..where((c) => c.status.equals('PENDING_APPROVAL'))).get();

    List<ReturnClaimWithItems> result = [];
    for (var claim in claims) {
      final audit =
          await (db.select(db.auditLog)..where(
                (a) =>
                    a.actionType.equals('RETURN_CLAIM_ITEMS') &
                    a.recordId.equals(claim.claimId),
              ))
              .getSingleOrNull();
      List<dynamic> items = [];
      if (audit != null && audit.newValue != null) {
        items = jsonDecode(audit.newValue!);
      }
      result.add(ReturnClaimWithItems(claim, items));
    }
    return result;
  }

  // Approve a claim and return items to stock
  Future<void> approveReturnClaim({
    required String claimId,
    required String adminUserId,
    required String refundMethod,
  }) async {
    await db.transaction(() async {
      final claim = await (db.select(
        db.returnsClaims,
      )..where((c) => c.claimId.equals(claimId))).getSingle();
      if (claim.status != 'PENDING_APPROVAL') return;

      final audit =
          await (db.select(db.auditLog)..where(
                (a) =>
                    a.actionType.equals('RETURN_CLAIM_ITEMS') &
                    a.recordId.equals(claim.claimId),
              ))
              .getSingleOrNull();

      if (audit != null && audit.newValue != null) {
        List<dynamic> items = jsonDecode(audit.newValue!);

        double totalRefund = 0;

        for (var item in items) {
          final itemId = item['itemId'] as String;
          final qty = item['qty'] as int;

          final invoiceItem = await (db.select(
            db.invoiceItems,
          )..where((i) => i.itemId.equals(itemId))).getSingle();

          // Return to FIFO batch
          final batchId = invoiceItem.batchId;
          final batch = await (db.select(
            db.fifoInventoryBatches,
          )..where((b) => b.batchId.equals(batchId))).getSingle();

          final newQty = batch.remainingQuantity + qty;
          await db
              .update(db.fifoInventoryBatches)
              .replace(batch.copyWith(remainingQuantity: newQty));

          totalRefund += (qty * invoiceItem.unitPrice);
        }

        // Apply Refund
        if (refundMethod == 'Khata Credit' &&
            claim.referenceInvoiceId != null) {
          final invoice =
              await (db.select(db.salesInvoices)..where(
                    (i) => i.invoiceId.equals(claim.referenceInvoiceId!),
                  ))
                  .getSingleOrNull();
          if (invoice != null && invoice.customerId != null) {
            final ledger =
                await (db.select(db.accountsLedger)
                      ..where((l) => l.accountId.equals(invoice.customerId!)))
                    .getSingleOrNull();
            if (ledger != null) {
              // Credit their account balance
              // Assuming balance is amount owed to us. Credit means decreasing their balance.
              final newBalance = ledger.currentBalance - totalRefund;
              await db
                  .update(db.accountsLedger)
                  .replace(ledger.copyWith(currentBalance: newBalance));
            }
          }
        }
      }

      await db
          .update(db.returnsClaims)
          .replace(
            claim.copyWith(
              status: 'APPROVED',
              refundMethod: Value(refundMethod),
              approvedBy: Value(adminUserId),
              approvedAt: Value(DateTime.now()),
            ),
          );
    });
  }

  // Reject a claim
  Future<void> rejectReturnClaim(String claimId, String adminUserId) async {
    final claim = await (db.select(
      db.returnsClaims,
    )..where((c) => c.claimId.equals(claimId))).getSingle();
    await db
        .update(db.returnsClaims)
        .replace(
          claim.copyWith(
            status: 'REJECTED',
            approvedBy: Value(adminUserId),
            approvedAt: Value(DateTime.now()),
          ),
        );
  }
}

class ReturnClaimWithItems {
  final ReturnsClaim claim;
  final List<dynamic> items;
  ReturnClaimWithItems(this.claim, this.items);
}
