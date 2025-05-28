import 'dart:convert';

class CustomerLoginResponse {
  final String Token;
  final String Role;
  final int UPId;

  CustomerLoginResponse({
    required this.Token,
    required this.Role,
    required this.UPId,
  });

  factory CustomerLoginResponse.fromJson(Map<String, dynamic> json) {
    return CustomerLoginResponse(
      Token: json['token'],
      Role: json['role'],
      UPId: json['upId'],
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
