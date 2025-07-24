import 'package:acne_detection_app/models/scan_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  var recentScans = <ScanModel>[].obs;
  var skinCareTips = <String>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadSkinCareTips();
    fetchRecentScans();
  }

  void fetchRecentScans() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('No user logged in');
      return;
    }

    try {
      final querySnapshot = await _firestore
          .collection('scans')
          .doc(user.uid)
          .collection('user_scans')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      final scans = querySnapshot.docs.map((doc) {
        return ScanModel.fromFirestore(doc.data(), doc.id);
      }).toList();

      recentScans.assignAll(scans);
    } catch (e) {
      print('Error fetching scans: $e');
      Get.snackbar('Error', 'Failed to load recent scans.');
    }
  }

  void loadSkinCareTips() {
    skinCareTips.assignAll([
      'Wash your face twice daily with a gentle cleanser.',
      'Use non-comedogenic moisturizers to avoid clogging pores.',
      'Avoid touching your face with unwashed hands.',
      'Apply sunscreen daily to protect your skin from UV damage.',
    ]);
  }
}