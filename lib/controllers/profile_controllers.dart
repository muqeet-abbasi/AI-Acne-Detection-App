
import 'package:acne_detection_app/view/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  // Observable variables
  var user = Rxn<UserModel>(); // To store user profile data
  var isDarkMode = false.obs; // To track dark mode state

  @override
  void onInit() {
    super.onInit();
    // Load dummy data for testing
    loadUserProfile();
  }

  // Load dummy user profile (replace with actual data)
  void loadUserProfile() {
    user(UserModel(
      name: 'John Doe',
      age: 25,
      skinType: 'Oily',
      scanHistory: [
        {'date': '2023-10-01', 'result': 'Mild Acne - Blackheads', 'confidence': '87%'},
        {'date': '2023-09-28', 'result': 'Moderate Acne - Whiteheads', 'confidence': '92%'},
        {'date': '2023-09-25', 'result': 'Severe Acne - Cysts', 'confidence': '78%'},
      ],
    ));
  }

  // Toggle dark mode
  void toggleDarkMode() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  // Delete user data
  void deleteUserData() {
    user(null);
    Get.snackbar('Success', 'User data deleted successfully.');
  }

   /// 🚪 Logout logic
  Future<void> logoutUser() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Also sign out from Google if logged in via Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Clear local data if needed
      user(null);

      // Navigate back to login screen
      Get.offAll(() => LoginScreen());; // Use your actual login route
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
      print(e);
    }
  }
}
