import 'package:flutter/foundation.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'dart:html' as html;

Future<void> convertHtmlToPdfAndPrint(
    String htmlContent, String patientName) async {
  if (kIsWeb) {
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    html.Url.revokeObjectUrl(url);
    return;
  }
  final targetPath = await getDownloadsDirectory();
  final currentDate = DateTime.now().toString().split(' ')[0];

  final targetFileName = '${patientName}_$currentDate.pdf';

  final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent, targetPath!.path, targetFileName);

  await Printing.layoutPdf(onLayout: (_) => generatedPdfFile.readAsBytes());
}
