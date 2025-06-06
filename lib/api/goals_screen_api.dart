import 'dart:convert';

import 'package:exe202_mobile_app/models/DTOs/error_message_reponse.dart';
import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GoalsScreenService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = FlutterSecureStorage();

  Future<dynamic> fetchGoals() async {
    final url = Uri.parse('$baseUrl/Goals');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Make sure this is a List

        List<GoalsResponseDTO> jsonResponse = (data as List)
            .map(
              (item) =>
                  GoalsResponseDTO.safeFromJson(item as Map<String, dynamic>),
            )
            .whereType<GoalsResponseDTO>()
            .toList();

        if (jsonResponse != null) {
          return jsonResponse;
        } else {
          return null;
        }
      } else {
        final data = jsonDecode(response.body);
        final errorResponse = ErrorMessageResponse.fromJson(data);

        return errorResponse;
      }
    } catch (e) {
      throw Exception(")>!ERROR!<( : $e");
    }
  }
}
