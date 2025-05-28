import 'dart:convert';

class ErrorMessageResponse {
  final String Message;
  final String Error;

  ErrorMessageResponse({required this.Message, required this.Error});

  factory ErrorMessageResponse.fromJson(Map<String, dynamic> json) {
    return ErrorMessageResponse(Message: json['message'], Error: json['error']);
  }
}
