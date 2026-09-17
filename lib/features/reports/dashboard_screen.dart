import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/security/auth_provider.dart';

import 'export_service.dart';

final todaySalesProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return 0.0;
  return db.reportsDao.getTodaySales();
});

final todayProfitProvider = FutureProvider<double>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return 0.0;
  return db.reportsDao.getTodayProfit();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    if (user == null) return const SizedBox.shrink();

    final isOperator = user.role == 'Operator';
    final isAdmin = user.role == 'Admin';

    final salesAsync = ref.watch(todaySalesProvider);
    final profitAsync = ref.watch(todayProfitProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (isAdmin) // Restricted entirely to Admin
                ElevatedButton.icon(
                  onPressed: () async {
                    final db = ref.read(databaseProvider);
                    if (db == null) return;
                    
                    // Simple mock export logic for dashboard reporting sales & profit
                    final sales = await db.reportsDao.getTodaySales();
                    final profit = await db.reportsDao.getTodayProfit();
                    
                    final rows = [
                      ['Metric', 'Value'],
                      ['Today Sales', sales],
                      ['Today Profit', profit],
                      ['Margin', sales > 0 ? (profit/sales).toStringAsFixed(2) : 0]
                    ];
                    
                    final svc = ExportService(db);
                    try {
                      final path = await svc.exportToCsv(user.id, rows, 'Dashboard_Report');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Exported to $path')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Export failed: $e')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Reports'),
                ),
            ],
          ),
          const SizedBox(height: 24),

          if (isOperator) ...[
            // Operator View: Today's Sales only, no profit margins
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Sales",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    salesAsync.when(
                      data: (sales) => Text(
                        "Rs $sales",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (e, st) => const Text('Error'),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Admin/Manager View
            Row(
              children: [
                _buildKpiCard(
                  "Today's Sales",
                  salesAsync.when(
                    data: (sales) => "Rs $sales",
                    loading: () => "...",
                    error: (e, st) => "Err",
                  ),
                ),
                const SizedBox(width: 16),
                _buildKpiCard(
                  "Gross Profit",
                  profitAsync.when(
                    data: (profit) => "Rs $profit",
                    loading: () => "...",
                    error: (e, st) => "Err",
                  ),
                  isHighlight: true,
                ),
                const SizedBox(width: 16),
                _buildKpiCard(
                  "Receivables",
                  "Rs 0",
                ), // Placeholder for Receivables
                const SizedBox(width: 16),
                _buildKpiCard(
                  "Low Stock",
                  "0 items",
                  isAlert: true,
                ), // Placeholder for Low Stock
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value, {
    bool isHighlight = false,
    bool isAlert = false,
  }) {
    return Expanded(
      child: Card(
        color: isHighlight
            ? Colors.teal.shade50
            : (isAlert ? Colors.amber.shade50 : null),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
