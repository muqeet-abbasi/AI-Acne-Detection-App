class ScanHistoryModel {
  String result;
  String timestamp;

  ScanHistoryModel({required this.result, required this.timestamp});

  factory ScanHistoryModel.fromJson(Map<String, dynamic> json) {
    return ScanHistoryModel(
      result: json['result'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'timestamp': timestamp,
    };
  }
}
