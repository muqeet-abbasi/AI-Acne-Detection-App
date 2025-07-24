import 'package:acne_detection_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ScanHistoryItem extends StatelessWidget {
  final Map<String, dynamic> scan;

  const ScanHistoryItem({super.key, required this.scan});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${scan['date']}',
              style: TextStyle(
                fontSize: 14,
                color: darkGrayText.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Result: ${scan['result']}',
              style: TextStyle(
                fontSize: 14,
                color: darkGrayText.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Confidence: ${scan['confidence']}',
              style: TextStyle(
                fontSize: 14,
                color: darkGrayText.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}