import 'package:acne_detection_app/view/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  var isLoading = false.obs;

  

  Future<void> signup(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar("Success", "Account created successfully");
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Signup Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Success", "Logged in successfully");
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User cancelled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString(), snackPosition: SnackPosition.TOP);
      print(e);
    }
  }



  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email first",
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password reset email sent!",
          snackPosition: SnackPosition.TOP);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Something went wrong",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
