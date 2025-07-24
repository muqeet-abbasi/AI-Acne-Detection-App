import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/view/widgets/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController _controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Use the app's background color
      body: SafeArea(
        child: Stack(
          children: [
            // Swipeable Slides
            PageView(
              onPageChanged: _controller.updatePage,
              children: const [
                OnboardingSlide(
                  icon: Icons.health_and_safety,
                  title: 'Welcome to Acne Detection',
                  description:
                      'Detect acne and get personalized skincare recommendations using AI.',
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor], // Use primary and secondary colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                OnboardingSlide(
                  icon: Icons.camera_alt,
                  title: 'How It Works',
                  description:
                      'Upload or capture an image, and our AI will analyze your skin condition.',
                  gradient: LinearGradient(
                    colors: [accentColor, highlightColor], // Use accent and highlight colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                OnboardingSlide(
                  icon: Icons.rocket_launch,
                  title: 'Get Started',
                  description: 'Start your journey to healthier skin today!',
                  gradient: LinearGradient(
                    colors: [successColor, warningColor], // Use success and warning colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
            // Page Indicator
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _controller.currentPage.value == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: _controller.currentPage.value == index
                            ? primaryColor // Use primaryColor for active dot
                            : darkGrayText.withOpacity(0.3), // Use darkGrayText for inactive dots
                      ),
                    );
                  }),
                );
              }),
            ),
            // Get Started Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.navigateToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // Use primaryColor for the button
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5, // Add elevation for a raised effect
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // White text for contrast
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}