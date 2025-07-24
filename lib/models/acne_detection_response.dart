class AcneDetectionResponse {
  final String acneSeverity;
  final dynamic reportData; // This can be either a String or a Map
  final int spotCount;
  final String visualizationUrl;
  
  // Computed properties to handle both formats
  String get analysis {
    if (reportData is String) {
      return reportData as String;
    } else if (reportData is Map) {
      return (reportData as Map)['analysis'] ?? '';
    }
    return '';
  }
  
  List<String> get recommendations {
    if (reportData is Map && (reportData as Map).containsKey('recommendations')) {
      return List<String>.from((reportData as Map)['recommendations']);
    }
    return []; // Return empty list if no recommendations
  }
  
  // Check if the skin is clear
  bool get isClearSkin => acneSeverity == 'Clear Skin';

  AcneDetectionResponse({
    required this.acneSeverity,
    required this.reportData,
    required this.spotCount,
    required this.visualizationUrl,
  });

  factory AcneDetectionResponse.fromJson(Map<String, dynamic> json) {
    return AcneDetectionResponse(
      acneSeverity: json['acne_severity'] ?? '',
      reportData: json['report'], // This could be a string or an object
      spotCount: json['spot_count'] ?? 0,
      visualizationUrl: json['visualization_url'] ?? '',
    );
  }
}