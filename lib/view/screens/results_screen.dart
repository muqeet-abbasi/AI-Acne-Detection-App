import 'package:acne_detection_app/constants/colors.dart';
import 'package:acne_detection_app/view/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/results_controller.dart';


class ResultsScreen extends StatelessWidget {
  final ResultsController _controller = Get.put(ResultsController());

  ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results & Recommendations'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:  BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Center(
                child: Text(
                  'Your Skin Health Matters!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detection Results Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                if (_controller.detectionResult.value != null) {
                  final result = _controller.detectionResult.value!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detection Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Acne Type: ${result.acneType}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: darkGrayText.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Confidence: ${result.confidence}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: darkGrayText.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Graphical Analysis Section (Placeholder)
                      const Text(
                        'Graphical Analysis',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: lightGrayBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Pie Chart or Bar Graph Here',
                            style: TextStyle(
                              fontSize: 16,
                              color: darkGrayText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Skincare Recommendations Section
                      const Text(
                        'Skincare Recommendations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: result.recommendations
                            .map(
                              (tip) => RecommendationCard(tip: tip),
                            )
                            .toList(),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text('No results available.'),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}