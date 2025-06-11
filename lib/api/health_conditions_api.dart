import 'dart:convert';

import 'package:exe202_mobile_app/models/DTOs/health_conditions_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/DTOs/error_message_reponse.dart';

class HealthConditionsApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<dynamic> fetchHealthConditions() async {
    Uri url = Uri.parse(
      '$baseUrl/HealthCondition/health-conditions?page=1&pageSize=33',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<HealthConditionsResponse> jsonResponse = (data['items'] as List)
            .map(
              (item) => HealthConditionsResponse.safeFromJson(
                item as Map<String, dynamic>,
              ),
            )
            .whereType<HealthConditionsResponse>()
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
