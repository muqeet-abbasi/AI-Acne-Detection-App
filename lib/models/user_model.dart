
class UserModel {
  final String name;
  final int age;
  final String skinType;
  final List<Map<String, dynamic>> scanHistory;

  UserModel({
    required this.name,
    required this.age,
    required this.skinType,
    required this.scanHistory,
  });
}