// models/detection_result_model.dart
class DetectionResultModel {
  final String acneType;
  final double confidence;
  final List<String> recommendations;

  DetectionResultModel({
    required this.acneType,
    required this.confidence,
    required this.recommendations,
  });
}