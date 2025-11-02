import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFHelper {
  /// Fungsi umum untuk mencetak data apapun dalam bentuk tabel
  static Future<void> printTable({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(width: 0.5),
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
              headers: headers,
              data: data,
            ),
            pw.SizedBox(height: 15),
            pw.Text("Total Data: ${data.length}",
                style: const pw.TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
