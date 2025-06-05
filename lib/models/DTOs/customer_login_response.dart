// lib/models/DTOs/customer_login_response.dart
class CustomerLoginResponse {
  final String Token;
  final String Role;
  final int UPId;
  final int CurrentStreak; // Thêm trường CurrentStreak
  final int MaxStreak;     // Thêm trường MaxStreak

  CustomerLoginResponse({
    required this.Token,
    required this.Role,
    required this.UPId,
    required this.CurrentStreak,
    required this.MaxStreak,
  });

  factory CustomerLoginResponse.fromJson(Map<String, dynamic> json) {
    return CustomerLoginResponse(
      Token: json['token'],
      Role: json['role'],
      UPId: json['upId'],
      CurrentStreak: json['currentStreak'] ?? 0,
      MaxStreak: json['maxStreak'] ?? 0,
    );
  }

  static CustomerLoginResponse? safeFromJson(Map<String, dynamic> json) {
    try {
      if (json['token'] == null ||
          json['role'] == null ||
          json['upId'] == null) {
        return null;
      }
      return CustomerLoginResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}