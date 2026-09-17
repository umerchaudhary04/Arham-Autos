import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaperWidthNotifier extends Notifier<int> {
  @override
  int build() => 80; // 80mm or 58mm
}
final paperWidthProvider = NotifierProvider<PaperWidthNotifier, int>(() => PaperWidthNotifier());

class PrintService {
  Future<void> printInvoiceSilently(String invoiceId, int paperWidthMm, Map<String, dynamic> invoiceData) async {
    final pdf = pw.Document();

    // Use a widely available font that supports Arabic/Urdu, e.g., Lateef or Noto Nastaliq Urdu.
    // In production, load from assets: final font = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNastaliqUrdu-Regular.ttf'));
    // For structural code, we fetch via PdfGoogleFonts.
    final urduFont = await PdfGoogleFonts.notoNastaliqUrduRegular();

    // Convert mm to points (1 mm = 2.83465 points)
    final double widthPoints = paperWidthMm == 58 ? 58 * 2.83465 : 80 * 2.83465;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(widthPoints, double.infinity, marginAll: 10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Arham Autos', style: pw.TextStyle(font: urduFont, fontSize: 20)),
              pw.Text('Invoice #$invoiceId', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              // Items placeholder
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Item Name', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('Qty x Price', style: const pw.TextStyle(fontSize: 10)),
                ]
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total', style: pw.TextStyle(font: urduFont, fontSize: 14)),
                  pw.Text('Rs ${invoiceData['totalAmount']}', style: const pw.TextStyle(fontSize: 14)),
                ]
              ),
              pw.SizedBox(height: 10),
              pw.Text('Thank you!', style: pw.TextStyle(font: urduFont, fontSize: 12)),
            ],
          );
        },
      ),
    );

    final Uint8List pdfBytes = await pdf.save();

    // SILENT DIRECT PRINT
    // Printing.directPrintPdf uses the default or named printer without OS dialog.
    final printers = await Printing.info();
    if (printers.directPrint) {
      final availablePrinters = await Printing.listPrinters();
      final targetPrinter = availablePrinters.where((p) => p.isDefault).firstOrNull ?? availablePrinters.firstOrNull;

      if (targetPrinter != null) {
        await Printing.directPrintPdf(
          printer: targetPrinter,
          onLayout: (PdfPageFormat format) async => pdfBytes,
        );
      }
    }
  }
}

final printServiceProvider = Provider<PrintService>((ref) => PrintService());
