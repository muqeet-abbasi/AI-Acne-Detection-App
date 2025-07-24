import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/controllers/login_controller.dart';
import 'package:acne_detection_app/controllers/signup_controller.dart';
import 'package:acne_detection_app/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming you have your colors defined in constants.dart (primaryColor)
class SignUpScreen extends StatelessWidget {
  final SignUpController signUpController = Get.put(SignUpController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // Custom text style for the header with primaryColor
    TextStyle customHeadlineStyle = const TextStyle(
      fontSize: 24, // Adjust the font size
      fontWeight: FontWeight.bold, // Bold font weight
      color: darkGrayText, // Using primaryColor from your palette
      letterSpacing: 1.2, // Optional: Add letter spacing
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkGrayText), // Back button color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Using the custom text style with primaryColor
                Text(
                  'Create a New Account',
                  style: customHeadlineStyle,
                ),
                const SizedBox(height: 24),

                // Email Field
                TextFormField(
                  onChanged: (value) => signUpController.email.value = value,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon:
                        const Icon(Icons.email, color: primaryColor), // 📩 Email Icon
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Smooth rounded corners
                    ),
                  ),
                ),

                const SizedBox(height: 16),

              // Password Field
                TextFormField(
                  onChanged: (value) => signUpController.password.value = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon:
                        const Icon(Icons.lock, color: primaryColor), // 🔒 Lock Icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

              // Confirm Password Field
                TextFormField(
                  onChanged: (value) =>
                      signUpController.confirmPassword.value = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: primaryColor), // 🔑 Confirm Password Icon
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Up Button wrapped with Obx to show loading
                Obx(() {
                  return SizedBox(
                    width: double.infinity, // Make button full width
                    height: 50, // Adjust button height
                    child: ElevatedButton(
                      onPressed: signUpController.isLoading.value
                          ? null
                          : () {
                              signUpController.signUp();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Use your theme color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // Smooth rounded corners
                        ),
                        elevation: 5, // Adds a subtle shadow effect
                        padding: const EdgeInsets.symmetric(
                            vertical: 14), // Adjust padding
                      ),
                      child: signUpController.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Ensures contrast
                                letterSpacing: 1.2, // Improves readability
                              ),
                            ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity, // Full-width button
                  height: 50, // Increased height
                  child: ElevatedButton.icon(
                    onPressed: () {
                      loginController.googleLogin();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Google button is usually white
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                        side: BorderSide(
                            color: Colors.grey.shade300), // Subtle border
                      ),
                      elevation: 3, // Light shadow for depth
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: Image.asset(
                      'assets/icons/google.png', // Google logo (Ensure you add it in assets)
                      height: 24, // Adjust icon size
                    ),
                    label: const Text(
                      'Sign Up with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87, // Dark text for contrast
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Login Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to Login screen
                        Get.back(); // Goes back to the previous screen (login)
                      },
                      child: const Text('Login',style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
