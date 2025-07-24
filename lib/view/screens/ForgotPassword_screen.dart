import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/controllers/forgotPassword_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const  IconThemeData(color: darkGrayText), // Back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center align all items
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Reset Your Password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkGrayText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your email address below. We will send you a password reset link.",
              textAlign: TextAlign.center, // Center text
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
           const SizedBox(height: 30),

            // Email Input Field
            TextFormField(
              onChanged: (value) =>
                  forgotPasswordController.email.value = value,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon:
                    const Icon(Icons.email, color: primaryColor), // Email Icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Send Reset Link Button
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: forgotPasswordController.isLoading.value
                      ? null
                      : () {
                          forgotPasswordController.sendResetLink();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: forgotPasswordController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send Reset Link",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Back to Login Button
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(
                    fontSize: 16,
                    color: accentColor,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
