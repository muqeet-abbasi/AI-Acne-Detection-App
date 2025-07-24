import 'dart:io';
import 'package:acne_detection_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewerScreen extends StatelessWidget {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  late final String filePath;
  
  PdfViewerScreen({super.key}) {
    // Safely extract the file path from arguments
    Map<String, dynamic> args = Get.arguments;
    filePath = args['filePath'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acne Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePdf,
            tooltip: 'Share PDF',
          ),
        ],
      ),
      body: _buildPdfViewer(),
    );
  }

  Widget _buildPdfViewer() {
    // Check if file exists
    final file = File(filePath);
    if (!file.existsSync()) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('File not found: $filePath'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    // File exists, show the PDF viewer
    return Stack(
      children: [
        SfPdfViewer.file(
          File(filePath),
          controller: _pdfViewerController,
          onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
            Get.snackbar(
              'Error',
              'Failed to load PDF: ${details.error}',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: _buildFloatingActionButtons(),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'zoom_in',
          mini: true,
          backgroundColor: primaryColor,
          child: const Icon(Icons.zoom_in, color: Colors.white),
          onPressed: () {
            _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
          },
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'zoom_out',
          mini: true,
          backgroundColor: primaryColor,
          child: const Icon(Icons.zoom_out, color: Colors.white),
          onPressed: () {
            _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
          },
        ),
      ],
    );
  }

  void _sharePdf() async {
    try {
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'My Acne Analysis Report',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}