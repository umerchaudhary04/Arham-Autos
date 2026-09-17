import 'dart:io';
// removed csv import
import 'package:excel/excel.dart';
import 'package:uuid/uuid.dart';
import '../../core/db/database.dart';
import 'package:drift/drift.dart' as drift;

class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  Future<String> exportToCsv(
    String userId,
    List<List<dynamic>> rows,
    String filenamePrefix,
  ) async {
    final StringBuffer sb = StringBuffer();
    for (var row in rows) {
      sb.writeln(
        row.map((e) => '"${e.toString().replaceAll('"', '""')}"').join(','),
      );
    }
    final csvData = sb.toString();

    // For Windows, default to Documents
    final documents = '${Platform.environment['USERPROFILE']}\\Documents';
    final path =
        '$documents\\${filenamePrefix}_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csvData);

    // Audit Log securely upon every export
    await _writeAuditLog(
      userId,
      'EXPORT_CSV',
      'Exported $filenamePrefix to CSV',
    );

    return path;
  }

  Future<String> exportToExcel(
    String userId,
    List<List<dynamic>> rows,
    String filenamePrefix,
  ) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    for (int r = 0; r < rows.length; r++) {
      for (int c = 0; c < rows[r].length; c++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
            .value = TextCellValue(
          rows[r][c].toString(),
        );
      }
    }

    final documents = '${Platform.environment['USERPROFILE']}\\Documents';
    final path =
        '$documents\\${filenamePrefix}_${DateTime.now().millisecondsSinceEpoch}.xlsx';

    final fileBytes = excel.save();
    if (fileBytes != null) {
      final file = File(path);
      await file.writeAsBytes(fileBytes);
    }

    // Audit Log securely upon every export
    await _writeAuditLog(
      userId,
      'EXPORT_EXCEL',
      'Exported $filenamePrefix to Excel',
    );

    return path;
  }

  Future<void> _writeAuditLog(
    String userId,
    String action,
    String details,
  ) async {
    await db
        .into(db.auditLog)
        .insert(
          AuditLogCompanion.insert(
            userId: userId,
            actionType: 'DATA_EXPORT', // Enforced by requirements
            targetTable: drift.Value('MULTIPLE'),
            recordId: drift.Value('EXPORT'),
            newValue: drift.Value(details),
          ),
        );
  }
}
