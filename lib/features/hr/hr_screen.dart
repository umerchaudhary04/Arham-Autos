import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/database.dart';
import '../../core/security/auth_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

final employeesProvider = FutureProvider<List<Employee>>((ref) async {
  final db = ref.watch(databaseProvider);
  if (db == null) return [];
  return db.select(db.employees).get();
});

class HrScreen extends ConsumerStatefulWidget {
  const HrScreen({super.key});

  @override
  ConsumerState<HrScreen> createState() => _HrScreenState();
}

class _HrScreenState extends ConsumerState<HrScreen> {
  void _showAddEmployeeDialog() {
    final nameCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final salaryCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: salaryCtrl,
              decoration: const InputDecoration(labelText: 'Salary'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty) return;
              final db = ref.read(databaseProvider)!;
              await db.into(db.employees).insert(EmployeesCompanion.insert(
                employeeId: const Uuid().v4(),
                fullName: nameCtrl.text,
                jobTitle: drift.Value(titleCtrl.text),
                currentSalary: drift.Value(double.tryParse(salaryCtrl.text) ?? 0.0),
              ));
              ref.invalidate(employeesProvider);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(employeesProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Employees', style: Theme.of(context).textTheme.headlineMedium),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Employee'),
                onPressed: _showAddEmployeeDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: employeesAsync.when(
              data: (emps) {
                if (emps.isEmpty) return const Center(child: Text('No employees found.'));
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Job Title')),
                    DataColumn(label: Text('Salary')),
                  ],
                  rows: emps.map((e) => DataRow(cells: [
                    DataCell(Text(e.fullName)),
                    DataCell(Text(e.jobTitle ?? '')),
                    DataCell(Text(e.currentSalary.toStringAsFixed(2))),
                  ])).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
