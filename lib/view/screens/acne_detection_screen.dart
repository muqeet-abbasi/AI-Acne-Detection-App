import 'dart:io';

import 'package:acne_detection_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/acne_detection_controller.dart';

class AcneDetectionScreen extends StatefulWidget {

  AcneDetectionScreen({super.key});

  @override
  State<AcneDetectionScreen> createState() => _AcneDetectionScreenState();
}

class _AcneDetectionScreenState extends State<AcneDetectionScreen> {
  final AcneDetectionController _controller =
    Get.isRegistered()?Get.find():  Get.put(AcneDetectionController());
    @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.resetImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acne Detection'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Preview Section
                  Center(
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _buildImagePreview(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image Selection Buttons
                  if (_controller.imageFile.value == null)
                    _buildImageSelectionButtons(),

                  // Detection Button (Only shown when an image is selected)
                  if (_controller.imageFile.value != null && !_controller.isApiCallInProgress.value)
                    _buildDetectionButton(),

                  // Reset Button (Only shown when an image is selected)
                  if (_controller.imageFile.value != null && !_controller.isApiCallInProgress.value)
                    _buildResetButton(),

                  const SizedBox(height: 20),

                  // Detection Results Section
                  if (_controller.detectionResponse.value != null)
                    _buildResultsSection(),

                     // PDF Generation and Viewing Buttons
                    _buildPdfButtons(),
                ],
              ),
            ),
            // Overlay loading indicator when API call is in progress
            if (_controller.isApiCallInProgress.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: primaryColor),
                        SizedBox(height: 20),
                        Text(
                          'Analyzing your skin...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

               // Overlay loading indicator for PDF generation
            if (_controller.isPdfGenerating.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: Colors.blue),
                        SizedBox(height: 20),
                        Text(
                          'Generating PDF report...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildImagePreview() {
    if (_controller.imageFile.value != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(_controller.imageFile.value!.path),
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Upload or capture an image to detect acne',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }

  Widget _buildImageSelectionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _controller.pickImage,
            icon: const Icon(Icons.photo_library, color: Colors.white),
            label: const Text('Gallery', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _controller.captureImage,
            icon: const Icon(Icons.camera_alt, color: Colors.white),
            label: const Text('Camera', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetectionButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: ElevatedButton.icon(
        onPressed: _controller.detectAcne,
        icon: const Icon(Icons.search, color: Colors.white),
        label: const Text(
          'Detect Acne',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: TextButton.icon(
        onPressed: _controller.resetImage,
        icon: const Icon(Icons.refresh),
        label: const Text('Choose Different Image'),
      ),
    );
  }

Widget _buildResultsSection() {
  final result = _controller.detectionResponse.value!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Results header
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'Results',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      
      const SizedBox(height: 15),
      
      // Severity and spot count
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInfoCard(
            'Severity',
            result.acneSeverity,
            Icons.assessment,
          ),
          _buildInfoCard(
            'Spots Detected',
            '${result.spotCount}',
            Icons.radar,
          ),
        ],
      ),
      
      const SizedBox(height: 20),
      
      // Visualization image
      if (result.visualizationUrl.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Visualization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: result.visualizationUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.error),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      
      const SizedBox(height: 20),
      
      // Analysis
      const Text(
        'Analysis',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          result.analysis,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      
      const SizedBox(height: 20),
      
      // Recommendations - only shown if there are any
      if (result.recommendations.isNotEmpty) ...[
        const Text(
          'Skincare Recommendations',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...result.recommendations.map((recommendation) => _buildRecommendationItem(recommendation)).toList(),
      ] else if (result.isClearSkin) ...[
        // Special message for clear skin
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Congratulations! Your skin appears clear. Continue with your current skincare routine.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        )
      ],
      
      const SizedBox(height: 20),
    ],
  );
}  

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPdfButtons() {
    return Column(
      children: [
        const SizedBox(height: 10),
        
        // "Save as PDF" button
        if (_controller.pdfFilePath.value == null)
          Container(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _controller.generateAndSavePdf,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text(
                'Save as PDF',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        
        // View PDF button - only shown when PDF is generated
        if (_controller.pdfFilePath.value != null)
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                     onPressed: _controller.openPdf,
                    icon: const Icon(Icons.remove_red_eye, color: Colors.white),
                    label: const Text(
                      'View PDF Report',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _controller.generateAndSavePdf,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Regenerate PDF',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        const SizedBox(height: 30),
      ],
    );}
  }