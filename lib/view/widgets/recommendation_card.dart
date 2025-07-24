import 'package:acne_detection_app/constants/colors.dart';
import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final String tip;

  const RecommendationCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.medical_services, color: primaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tip,
                style: TextStyle(
                  fontSize: 14,
                  color: darkGrayText.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}