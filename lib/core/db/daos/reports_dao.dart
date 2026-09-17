import 'package:drift/drift.dart';
import '../database.dart';

part 'reports_dao.g.dart';

@DriftAccessor(tables: [SalesInvoices, InvoiceItems])
class ReportsDao extends DatabaseAccessor<AppDatabase> with _$ReportsDaoMixin {
  ReportsDao(AppDatabase db) : super(db);

  /// Get today's total sales
  Future<double> getTodaySales() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final query = select(salesInvoices)
      ..where((i) => i.createdAt.isBiggerOrEqualValue(startOfDay));

    final invoices = await query.get();
    return invoices.fold<double>(0.0, (sum, inv) => sum + inv.finalAmount);
  }

  /// Get today's profit (Admin/Manager only, handled in UI)
  Future<double> getTodayProfit() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // Simplistic profit calculation: finalAmount - (sum of unitCogs * qty)
    final invoices = await (select(
      salesInvoices,
    )..where((i) => i.createdAt.isBiggerOrEqualValue(startOfDay))).get();

    double totalProfit = 0.0;

    for (var inv in invoices) {
      final items = await (select(
        invoiceItems,
      )..where((item) => item.invoiceId.equals(inv.invoiceId))).get();
      double cost = items.fold(
        0.0,
        (sum, item) => sum + (item.unitCogs * item.quantity),
      );
      // Adjusting for invoice level discount isn't exact here, but sufficient for structural placeholder
      totalProfit += (inv.finalAmount - cost);
    }

    return totalProfit;
  }
}
