import 'package:cloud_firestore/cloud_firestore.dart';

class ScanModel {
  final String id;
  final String date;
  final String result;
  final int spotCount;

  ScanModel({
    required this.id,
    required this.date,
    required this.result,
    required this.spotCount,
  });

  factory ScanModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    return ScanModel(
      id: docId,
      date: _formatDate(timestamp),
      result: data['acne_severity'] ?? 'Unknown',
      spotCount: data['spot_count'] ?? 0,
    );
  }

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}