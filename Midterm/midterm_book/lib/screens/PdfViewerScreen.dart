import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart'; // Import the pdfx package

class PdfViewerScreen extends StatefulWidget {
  final String pdfPath;

  PdfViewerScreen({required this.pdfPath});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfController _pdfController;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openFile(widget.pdfPath),
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
        backgroundColor: Colors.orange,
      ),
      body: PdfView(
        controller: _pdfController,
        scrollDirection: Axis.vertical,
        onDocumentError: (error) {
          print('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load PDF: $error')),
          );
        },


        onPageChanged: (pageIndex) {
          print('Page changed to: $pageIndex');
        },
      ),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }
}
