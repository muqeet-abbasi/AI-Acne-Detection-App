// controllers/onboarding_controller.dart
import 'package:acne_detection_app/view/screens/login_screen.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // Observable variables
  var currentPage = 0.obs; // To track the current slide

  // Update current page
  void updatePage(int index) {
    currentPage(index);
  }

  // Navigate to login/signup screen
  void navigateToLogin() {
    Get.offAll(() => LoginScreen()); // Replace with your login/signup route
  }
}