import 'package:notes/core/imports/imports.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrintService {
  /// Generates and prints a PDF from a [Note] with Arabic support and page borders
  static Future<void> printNote(BuildContext context, Note note) async {
    final pdf = pw.Document();
    final arabicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Amiri-Regular.ttf'),
    );
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Container(),
              ),
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.Container(
                  alignment: pw.Alignment.topRight,
                  padding: pw.EdgeInsets.all(10), // Adding padding for text
                  child: pw.Text(
                    note.content,
                    style: pw.TextStyle(font: arabicFont, fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();
    debugPrint('PDF generated, byte length: ${pdfBytes.length}');

    /// Use Printing to print the generated PDF directly
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
    Navigator.of(context).pop();
  }
}
