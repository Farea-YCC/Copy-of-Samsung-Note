import 'package:notes/core/imports/imports.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
//
// class PrintService {
//   /// Generates and prints a PDF from a [Note] with Arabic support and page borders
//   static Future<void> printNote(BuildContext context, Note note) async {
//     final pdf = pw.Document();
//     final arabicFont = pw.Font.ttf(
//       await rootBundle.load('assets/fonts/Amiri-Regular.ttf'),
//     );
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Stack(
//             children: [
//               pw.Positioned.fill(
//                 child: pw.Container(),
//               ),
//               pw.Directionality(
//                 textDirection: pw.TextDirection.rtl,
//                 child: pw.Container(
//                   alignment: pw.Alignment.topRight,
//                   padding: pw.EdgeInsets.all(10), // Adding padding for text
//                   child: pw.Text(
//                     note.content,
//                     style: pw.TextStyle(font: arabicFont, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//
//     final pdfBytes = await pdf.save();
//     debugPrint('PDF generated, byte length: ${pdfBytes.length}');
//
//     /// Use Printing to print the generated PDF directly
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes);
//     Navigator.of(context).pop();
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
class PrintService {
  /// Generates and prints a PDF from given content with multilingual support and professional formatting.
  static Future<void> printContent({
    required BuildContext context,
    required String content,
    String title = "",
    required String fontPath, // Path to the font file in assets
    bool isRtl = false, // Determines the text direction (RTL or LTR)
  }) async {
    try {
      // Create a PDF document
      final pdf = pw.Document();

      // Load the custom font
      final font = pw.Font.ttf(
        await rootBundle.load(fontPath),
      );

      // Add a page to the PDF
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(20),
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Optional title
                if (title.isNotEmpty)
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    textAlign: isRtl ? pw.TextAlign.right : pw.TextAlign.left,
                  ),
                pw.SizedBox(height: 10),
                // Main content
                pw.Directionality(
                  textDirection:
                  isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                  child: pw.Text(
                    content,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Generate PDF bytes
      final pdfBytes = await pdf.save();
      debugPrint('PDF generated, byte length: ${pdfBytes.length}');

      // Use the Printing package to print the generated PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );

      // Close the dialog or navigate back
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error generating or printing PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to print content: $e'),
        ),
      );
    }
  }
}