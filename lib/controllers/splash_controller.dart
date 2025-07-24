import 'package:acne_detection_app/view/screens/onboarding%20_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 6));
    // Replace 'OnboardingView' with your next screen route name
    Get.offAll(() => OnboardingScreen());
  }
}