import 'package:get/get.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;

  final isLoading = false.obs;

  final AuthController _authController = Get.find();

  void signUp() async {
    if (email.value.isEmpty || password.value.isEmpty || confirmPassword.value.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;

    await _authController.signup(email.value, password.value);

    isLoading.value = false;
  }
}
