import 'dart:io';
import 'package:acne_detection_app/view/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/acne_detection_response.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AcneDetectionController extends GetxController {
  var imageFile = Rxn<XFile>();
  var isLoading = false.obs;
  var isCameraInitialized = false.obs;
  var detectionResponse = Rxn<AcneDetectionResponse>();
  var isApiCallInProgress = false.obs;
  var pdfFilePath = Rxn<String>();
  var isPdfGenerating = false.obs;

  CameraController? cameraController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        Get.snackbar('Error', 'Camera permission denied.');
        return;
      }
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar('Error', 'No camera available.');
        return;
      }
      final firstCamera = cameras.first;
      cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
      await cameraController!.initialize();
      isCameraInitialized(true);
    } catch (e) {
      isCameraInitialized(false);
      Get.snackbar('Error', 'Failed to initialize camera: $e');
    }
  }

  Future<void> captureImage() async {
    if (isApiCallInProgress.value) {
      Get.snackbar('Processing',
          'Please wait while the current image is being analyzed.');
      return;
    }
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      Get.snackbar('Error', 'Camera permission denied.');
      return;
    }
    final _picker = ImagePicker();
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        imageFile(pickedFile);
        detectionResponse(null);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: $e');
    }
  }

  Future<void> pickImage() async {
    if (isApiCallInProgress.value) {
      Get.snackbar('Processing',
          'Please wait while the current image is being analyzed.');
      return;
    }
    await _requestGalleryPermission();
    final _picker = ImagePicker();
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile(pickedFile);
        detectionResponse(null);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        return;
      }
      var status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.snackbar('Permission Denied',
            'Gallery access is required to upload images.');
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        Get.snackbar('Permission Denied', 'Gallery access is required.');
      }
    }
  }

  void resetImage() {
    if (!isApiCallInProgress.value) {
      imageFile.value = null;
      detectionResponse.value = null;
      detectionResponse.refresh();
    } else {
      Get.snackbar('Processing',
          'Please wait while the current image is being analyzed.');
    }
  }

  Future<void> detectAcne() async {
    if (imageFile.value == null) {
      Get.snackbar('Error', 'Please upload an image first.');
      return;
    }

    isApiCallInProgress(true);
    isLoading(true);

    try {
      // Verify user authentication
      final user = _auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        Get.snackbar('Error', 'User not authenticated. Please log in.');
        return;
      }
      print('Authenticated user: ${user.uid}');

      // API call
      final file = File(imageFile.value!.path);
      final uri = Uri.parse('http://10.8.160.189:5000/analyze');
      var request = http.MultipartRequest('POST', uri);
      var multipartFile = await http.MultipartFile.fromPath('image', file.path);
      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print('API response status: ${response.statusCode}');
      print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final result = AcneDetectionResponse.fromJson(jsonResponse);
        detectionResponse(result);
        print(
            'Parsed API response: severity=${result.acneSeverity}, spots=${result.spotCount}');

        // Store in Firestore
        try {
          await _firestore
              .collection('scans')
              .doc(user.uid)
              .collection('user_scans')
              .add({
            'acne_severity': result.acneSeverity,
            'spot_count': result.spotCount,
            'timestamp': FieldValue.serverTimestamp(),
          });
          print('Firestore write successful');
          Get.snackbar('Success', 'Scan saved to database.',
              backgroundColor: Colors.green.shade100);
        } catch (firestoreError) {
          print('Firestore write error: $firestoreError');
          Get.snackbar(
              'Error', 'Failed to save scan to database: $firestoreError');
        }
      } else {
        print('API error: status=${response.statusCode}');
        Get.snackbar(
            'Error', 'Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      print('General error in detectAcne: $e');
      Get.snackbar('Error', 'Failed to analyze image: $e');
    } finally {
      isLoading(false);
      isApiCallInProgress(false);
    }
  }

  // Future<bool> requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.storage.isGranted) return true;

  //     if (Platform.version.contains("30") ||
  //         Platform.version.contains("31") ||
  //         Platform.version.contains("33")) {
  //       var status = await Permission.manageExternalStorage.request();
  //       return status.isGranted;
  //     } else {
  //       var status = await Permission.storage.request();
  //       return status.isGranted;
  //     }
  //   }
  //   return true; // For iOS or other platforms
  // }

 Future<void> generateAndSavePdf() async {
  if (detectionResponse.value == null) {
    Get.snackbar('Error', 'No detection results to save.');
    return;
  }

  isPdfGenerating(true);

  try {
    final result = detectionResponse.value!;
    final imageBytes = await File(imageFile.value!.path).readAsBytes();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Acne Detection Report',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text(
              'Generated on: ${DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now())}',
              style: pw.TextStyle(
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700),
            ),
            pw.Divider(),
          ],
        ),
        build: (context) => [
          pw.Text('Original Image',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Center(
            child: pw.Container(
              height: 250,
              width: 250,
              decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300)),
              child:
                  pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Analysis Summary',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              _buildPdfInfoBox('Severity', result.acneSeverity),
              _buildPdfInfoBox('Spots Detected', '${result.spotCount}'),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Detailed Analysis',
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Text(result.analysis, style: pw.TextStyle(fontSize: 14)),
          ),
          pw.SizedBox(height: 20),
          if (result.recommendations.isNotEmpty) ...[
            pw.Text('Skincare Recommendations',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...result.recommendations
                .map((recommendation) => pw.Padding(
                      padding: pw.EdgeInsets.only(bottom: 5),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('• ',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Expanded(child: pw.Text(recommendation)),
                        ],
                      ),
                    ))
                .toList(),
          ] else if (result.isClearSkin) ...[
            pw.Text('Recommendations',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.green),
                borderRadius: pw.BorderRadius.circular(5),
                color: PdfColors.green50,
              ),
              child: pw.Text(
                'Congratulations! Your skin appears clear. Continue with your current skincare routine.',
                style: pw.TextStyle(fontSize: 14),
              ),
            ),
          ],
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 5),
          pw.Center(
            child: pw.Text(
              'This report is generated by your Acne Detection App.',
              style: pw.TextStyle(
                  fontSize: 10,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700),
            ),
          ),
        ],
      ),
    );

    // ✅ Save to app-specific external folder (visible in Files app > Android/data/)
    final directory = await getExternalStorageDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '${directory!.path}/acne_report_$timestamp.pdf';

    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    pdfFilePath(filePath); // your variable
    print('PDF saved at:\n$filePath');
    Get.snackbar('Success', 'PDF saved at:\n$filePath',
        backgroundColor: Colors.green.shade100);
  } catch (e) {
    Get.snackbar('Error', 'Failed to generate PDF: $e');
  } finally {
    isPdfGenerating(false);
  }
}

  void openPdf() {
    if (pdfFilePath.value != null) {
      Get.to(() => PdfViewerScreen(),
          arguments: {'filePath': pdfFilePath.value},
          transition: Transition.rightToLeft);
    } else {
      Get.snackbar(
          'Error', 'No PDF file available. Please generate a report first.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  pw.Widget _buildPdfInfoBox(String title, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: pw.EdgeInsets.symmetric(horizontal: 5),
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
        ),
        child: pw.Column(
          children: [
            pw.Text(title,
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            pw.SizedBox(height: 5),
            pw.Text(value,
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
