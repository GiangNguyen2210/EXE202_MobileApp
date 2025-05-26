import 'dart:convert';

class CustomerLoginResponse{
  final String Token;
  final String Role;
  final int UPId;

  CustomerLoginResponse({
    required this.Token,
    required this.Role,
    required this.UPId
  });

  factory CustomerLoginResponse.fromJson(Map<String, dynamic> json){
    return CustomerLoginResponse(
        Token: json['token'],
        Role: json['role'],
        UPId: json['upId'],

    );
  }
}