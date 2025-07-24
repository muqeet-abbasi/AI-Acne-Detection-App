import 'package:get/get.dart';
import 'auth_controller.dart';

class ForgotPasswordController extends GetxController {
  final AuthController _authController = Get.find();

  var email = ''.obs;
  var isLoading = false.obs;

  void sendResetLink() async {
    if (email.value.isEmpty) {
      Get.snackbar("Error", "Please enter your email",
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      await _authController.resetPassword(email.value);
    } finally {
      isLoading(false);
    }
  }
}
