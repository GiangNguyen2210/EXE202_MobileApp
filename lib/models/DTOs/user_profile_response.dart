class UserProfileResponse {
  final int upId;
  final String fullName;
  final String? username;
  final int? age;
  final String? gender;
  final List<String> allergies;
  final List<String> healthConditions;
  final String userId;
  final String email;
  final String? role;
  final String? userPicture;

  UserProfileResponse({
    required this.upId,
    required this.fullName,
    this.username,
    this.age,
    this.gender,
    required this.allergies,
    required this.healthConditions,
    required this.userId,
    required this.email,
    this.role,
    this.userPicture,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      upId: json['uPId'] ?? 0,
      fullName: json['fullName'] ?? '',
      username: json['username'],
      age: json['age'],
      gender: json['gender'],
      allergies: List<String>.from(json['allergies'] ?? []),
      healthConditions: List<String>.from(json['healthConditions'] ?? []),
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      userPicture: json['userPicture'],
    );
  }
}
