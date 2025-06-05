class HealthCondition {
  final String condition;
  final String? status;

  HealthCondition({
    required this.condition,
    this.status,
  });

  factory HealthCondition.fromJson(Map<String, dynamic> json) {
    return HealthCondition(
      condition: json['condition'] ?? '',
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'status': status,
    };
  }
}

class UserProfileResponse {
  final int upId;
  final String fullName;
  final String? username;
  final int? age;
  final String? gender;
  final List<String> allergies;
  final List<HealthCondition> healthConditions;
  final String userId;
  final String email;
  final String? role;
  final String? userPicture;
  final String? phoneNumber;
  final int? subscriptionId;
  final DateTime? endDate;
  final int? streak; // Thêm field streak

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
    this.phoneNumber,
    this.subscriptionId,
    this.endDate,
    this.streak = 0, // Giá trị mặc định
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      upId: json['uPId'] ?? 0,
      fullName: json['fullName'] ?? '',
      username: json['username'],
      age: json['age'],
      gender: json['gender'],
      allergies: List<String>.from(json['allergies'] ?? []),
      healthConditions: (json['healthConditions'] as List<dynamic>? ?? [])
          .map((item) => HealthCondition(condition: item is Map ? (item['condition'] ?? item.toString()) : item.toString(), status: null))
          .toList(),
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
      userPicture: json['userPicture'],
      phoneNumber: json['phoneNumber'],
      subscriptionId: json['subscriptionId'],
      endDate: json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      streak: json['streak'] ?? 0, // Thêm mapping cho streak
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uPId': upId,
      'fullName': fullName,
      'username': username,
      'age': age,
      'gender': gender,
      'allergies': allergies,
      'healthConditions': healthConditions.map((hc) => hc.toJson()).toList(),
      'userId': userId,
      'email': email,
      'role': role,
      'userPicture': userPicture,
      'phoneNumber': phoneNumber,
      'subscriptionId': subscriptionId,
      'endDate': endDate?.toIso8601String(),
      'streak': streak, // Thêm vào toJson
    };
  }
}