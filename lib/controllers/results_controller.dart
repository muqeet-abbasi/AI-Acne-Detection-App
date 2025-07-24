
import 'package:acne_detection_app/models/detection_result_model.dart';
import 'package:get/get.dart';


class ResultsController extends GetxController {
  // Observable variables
  var detectionResult = Rxn<DetectionResultModel>(); // To store detection results

  @override
  void onInit() {
    super.onInit();
    // Load dummy data for testing
    loadDetectionResult();
  }

  // Load dummy detection result (replace with actual data)
  void loadDetectionResult() {
    detectionResult(DetectionResultModel(
      acneType: 'Mild Acne - Blackheads',
      confidence: 87.0,
      recommendations: [
        'Wash your face twice daily with a gentle cleanser.',
        'Use non-comedogenic moisturizers.',
        'Avoid touching your face with unwashed hands.',
        'Apply sunscreen daily to protect your skin from UV damage.',
      ],
    ));
  }
}