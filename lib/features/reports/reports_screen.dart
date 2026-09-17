import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import 'export_service.dart';

final exportServiceProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return ExportService(db!);
});

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  bool _isExporting = false;

  void _exportData(String format) async {
    final user = ref.read(authProvider).user;
    if (user == null || user.role != 'Admin') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export restricted to Admin only.')),
      );
      return;
    }

    setState(() => _isExporting = true);

    try {
      final db = ref.read(databaseProvider)!;
      final exportSvc = ref.read(exportServiceProvider);

      // Fetch data
      final invoices = await db.select(db.salesInvoices).get();

      List<List<dynamic>> rows = [
        [
          'Invoice ID',
          'Date',
          'Customer ID',
          'Total Amount',
          'Discount',
          'Final Amount',
          'Total COGS',
          'Margin',
        ],
      ];

      for (var inv in invoices) {
        final items = await (db.select(
          db.invoiceItems,
        )..where((i) => i.invoiceId.equals(inv.invoiceId))).get();
        double totalCogs = items.fold(
          0.0,
          (sum, item) => sum + (item.unitCogs * item.quantity),
        );
        double margin = inv.finalAmount - totalCogs;

        rows.add([
          inv.invoiceId,
          inv.createdAt.toIso8601String(),
          inv.customerId ?? 'Walk-in',
          inv.totalAmount,
          inv.discount,
          inv.finalAmount,
          totalCogs,
          margin,
        ]);
      }

      String path;
      if (format == 'CSV') {
        path = await exportSvc.exportToCsv(user.id, rows, 'Sales_Report');
      } else {
        path = await exportSvc.exportToExcel(user.id, rows, 'Sales_Report');
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Exported to $path')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export Failed: $e')));
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final isAdmin = user?.role == 'Admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Analytics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 24),
            Text(
              'Advanced Reports',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 48),
            if (isAdmin) ...[
              const Text('Export Sales Data (Includes COGS & Margins)'),
              const SizedBox(height: 16),
              if (_isExporting)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.table_chart),
                      label: const Text('Export to CSV'),
                      onPressed: () => _exportData('CSV'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.grid_on),
                      label: const Text('Export to Excel'),
                      onPressed: () => _exportData('EXCEL'),
                    ),
                  ],
                ),
            ] else ...[
              const Text(
                'You do not have permission to view or export advanced reports.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
