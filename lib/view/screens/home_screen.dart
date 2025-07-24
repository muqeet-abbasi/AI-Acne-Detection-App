import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/controllers/home_controller.dart';
import 'package:acne_detection_app/view/screens/acne_detection_screen.dart';
import 'package:acne_detection_app/view/screens/profile_screen.dart'; // Import the profile screen
import 'package:acne_detection_app/view/widgets/recent_scan_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                _buildHeroSection(),

                // Recent Scans Section
                _buildRecentScansSection(),

                // Skin Care Tips Section
                _buildSkinCareTipsSection(),

                // Scan Now Button
                _buildScanNowButton(),
              ],
            ),
          ),

          // Profile Icon Button (Top-Right Corner)
          Positioned(
            top: 40, // Adjust position as needed
            right: 20, // Adjust position as needed
            child: IconButton(
              icon: const Icon(
                Icons.person,
                color: Colors.white, // White color for visibility on gradient
                size: 30, // Adjust size as needed
              ),
              onPressed: () {
                // Navigate to Profile Screen
                Get.to(ProfileScreen());
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Hero Section
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Welcome Back!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your skin deserves the best care. Start scanning now!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Build Recent Scans Section
  Widget _buildRecentScansSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Scans',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkGrayText,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _controller.recentScans.length,
                itemBuilder: (context, index) {
                  final scan = _controller.recentScans[index];
                  return RecentScanItem(scan: scan);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Skin Care Tips Section
  Widget _buildSkinCareTipsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skin Care Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkGrayText,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5, // Adjust aspect ratio
              ),
              itemCount: _controller.skinCareTips.length,
              itemBuilder: (context, index) {
                final tip = _controller.skinCareTips[index];
                return SizedBox(
                  height: 150, // Fixed height
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.medical_services,
                              color: primaryColor),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 14,
                                color: darkGrayText.withOpacity(0.8),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Scan Now Button
  Widget _buildScanNowButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Acne Detection Screen
            Get.to(AcneDetectionScreen());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Scan Now',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
