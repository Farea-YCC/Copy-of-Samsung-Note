import 'package:flutter_quill/quill_delta.dart';
import 'package:notes/core/imports/imports.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart'; // Make sure to import the rootBundle
import 'package:printing/printing.dart';
class PrintService {
  static const double _defaultFontSize = 14.0;
  static const double _defaultLineHeight = 1.5;
  static const double _defaultPadding = 8.0;
  static const double _pageMargin = 32.0;

  // Fonts configuration
  static final Map<String, String> _fonts = {
    'arabic': 'assets/fonts/Amiri-Regular.ttf',
    'english': 'assets/fonts/Roboto-Regular.ttf',
  };

  // Custom print configuration
  static final PrintConfiguration _printConfig = PrintConfiguration(
    pageFormat: PdfPageFormat.a4,
    margin: pw.EdgeInsets.all(_pageMargin),
  );

  // Generates and prints a PDF from a [Note] with Arabic and English support
  static Future<bool> printNote(
      BuildContext context, Note note) async {
    try {
      final fonts = await _loadFonts();
      final pdf = await _generatePDF(note, fonts);
      return await _printPDF(pdf);
    } on FontLoadingException catch (e) {
      _handleError(context, 'Font loading error: ${e.message}');
      return false;
    } on PDFGenerationException catch (e) {
      _handleError(context, 'PDF generation error: ${e.message}');
      return false;
    } catch (e) {
      _handleError(context, 'An unexpected error occurred');
      return false;
    }
  }

  // Loads required fonts
  static Future<Map<String, pw.Font>> _loadFonts() async {
    try {
      final Map<String, pw.Font> loadedFonts = {};
      for (final entry in _fonts.entries) {
        loadedFonts[entry.key] = pw.Font.ttf(
          await rootBundle.load(entry.value),
        );
      }
      return loadedFonts;
    } catch (e) {
      throw FontLoadingException('Failed to load fonts: $e');
    }
  }

  // Generates PDF document
  static Future<pw.Document> _generatePDF(Note note,
      Map<String, pw.Font> fonts) async {
    try {
      final pdf = pw.Document();
      final delta = Delta.fromJson(jsonDecode(note.content));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: _printConfig.pageFormat,
          margin: _printConfig.margin,
          header: (context) => _buildHeader(note),
          footer: (context) => _buildFooter(context),
          build: (context) =>
          [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: _buildFormattedContent(delta, fonts),
            ),
          ],
        ),
      );

      return pdf;
    } catch (e) {
      throw PDFGenerationException('Failed to generate PDF: $e');
    }
  }

  // Prints the generated PDF
  static Future<bool> _printPDF(pw.Document pdf) async {
    try {
      final pdfBytes = await pdf.save();
      final result = await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        usePrinterSettings: true,
      );
      return result;
    } catch (e) {
      throw PrintingException('Failed to print PDF: $e');
    }
  }

  // Builds formatted content with proper Arabic and English text handling
  static List<pw.Widget> _buildFormattedContent(
      Delta delta,
      Map<String, pw.Font> fonts) {
    final widgets = <pw.Widget>[];
    final textSegments = <TextSegment>[];
    String currentText = '';
    Map<String, dynamic>? currentAttributes;

    // Process delta operations
    for (final op in delta.toList()) {
      if (op.data is String) {
        if (currentAttributes != op.attributes) {
          if (currentText.isNotEmpty) {
            textSegments.add(TextSegment(
              text: currentText,
              attributes: currentAttributes,
            ));
          }
          currentText = op.data as String;
          currentAttributes = op.attributes;
        } else {
          currentText += op.data as String;
        }
      }
    }

    // Add last segment
    if (currentText.isNotEmpty) {
      textSegments.add(TextSegment(
        text: currentText,
        attributes: currentAttributes,
      ));
    }

    // Build widgets from segments
    for (final segment in textSegments) {
      final isArabic = _containsArabic(segment.text);
      final style = _createTextStyle(
        segment.attributes,
        isArabic ? fonts['arabic']! : fonts['english']!,
      );

      widgets.add(
        pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Padding(
            padding: pw.EdgeInsets.only(bottom: _defaultPadding),
            child: pw.Text(
              segment.text,
              style: style,
              textAlign: pw.TextAlign.right,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  // Creates text style with formatting
  static pw.TextStyle _createTextStyle(
      Map<String, dynamic>? attributes,
      pw.Font font) {
    var style = pw.TextStyle(
      font: font,
      fontSize: _defaultFontSize,
      height: _defaultLineHeight,
    );

    if (attributes == null) return style;

    return style.copyWith(
      fontWeight: attributes['bold'] == true ? pw.FontWeight.bold : null,
      fontStyle: attributes['italic'] == true ? pw.FontStyle.italic : null,
      decoration: attributes['underline'] == true
          ? pw.TextDecoration.underline
          : null,
      color: attributes['color'] != null
          ? _parseColor(attributes['color'])
          : null,
      fontSize: attributes['size'] != null
          ? double.tryParse(attributes['size'].toString())
          : null,
    );
  }

  // Builds header for PDF pages
  static pw.Widget _buildHeader(Note note) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: pw.EdgeInsets.only(bottom: _defaultPadding),
      child: pw.Text(
        note.title,
        style: pw.TextStyle(
          fontSize: _defaultFontSize * 1.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  // Builds footer for PDF pages
  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: pw.EdgeInsets.only(top: _defaultPadding),
      child: pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: pw.TextStyle(fontSize: _defaultFontSize * 0.8),
      ),
    );
  }

  // Error handling with custom dialog
  static void _handleError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Checks if the text contains Arabic characters
  static bool _containsArabic(String text) {
    return RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(text);
  }

  // Parses color from a hex string (e.g., #FF5733) to PDF color
  static PdfColor _parseColor(String colorString) {
    try {
      final hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        final r = int.parse(hex.substring(0, 2), radix: 16);
        final g = int.parse(hex.substring(2, 4), radix: 16);
        final b = int.parse(hex.substring(4, 6), radix: 16);
        return PdfColor.fromInt(r << 16 | g << 8 | b);
      }
      return PdfColor.fromInt(0x000000); // Default to black
    } catch (e) {
      return PdfColor.fromInt(0x000000); // Default to black on error
    }
  }
}

// Custom exceptions
class FontLoadingException implements Exception {
  final String message;
  FontLoadingException(this.message);
}

class PDFGenerationException implements Exception {
  final String message;
  PDFGenerationException(this.message);
}

class PrintingException implements Exception {
  final String message;
  PrintingException(this.message);
}

// Helper classes
class PrintConfiguration {
  final PdfPageFormat pageFormat;
  final pw.EdgeInsets margin;

  PrintConfiguration({
    required this.pageFormat,
    required this.margin,
  });
}

class TextSegment {
  final String text;
  final Map<String, dynamic>? attributes;

  TextSegment({
    required this.text,
    this.attributes,
  });
}
