import 'package:get/get.dart';
import 'auth_controller.dart'; // import your AuthController

class LoginController extends GetxController {
  final AuthController _authController = Get.find();

  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;

  bool validateForm(String email, String password) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      return false;
    }
    if (password.isEmpty) {
      return false;
    }
    return true;
  }

  void login() {
    if (validateForm(email.value, password.value)) {
      _authController.login(email.value, password.value);
    } else {
      Get.snackbar("Error", "Invalid email or password",
          snackPosition: SnackPosition.TOP);
    }
  }

  void googleLogin() {
    _authController.signInWithGoogle();
  }
}
