import 'package:acne_detection_app/view/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants/colors.dart';
import 'view/screens/home_screen.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  // Initialize GetX controllers
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Acne Detection App',
      theme: ThemeData(
        primaryColor: primaryColor, // Replace with Colors.blue.shade700 if undefined
        colorScheme: const ColorScheme.light(
          primary: primaryColor, // Replace with Colors.blue.shade700 if undefined
          secondary: accentColor, // Replace with Colors.orange.shade600 if undefined
        ),
        scaffoldBackgroundColor: backgroundColor, // Replace with Colors.grey.shade100 if undefined
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
          bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
       ),
      ),
      home: SplashView(),
      debugShowCheckedModeBanner: false,
    );
  }
}