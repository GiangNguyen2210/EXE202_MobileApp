import 'dart:convert';

import 'package:exe202_mobile_app/models/DTOs/ingredient_reponse.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/DTOs/error_message_reponse.dart';

class AllergiesScreenService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<dynamic> fetchIngredients({
    required String searchTerm,
    int page = 1,
    int pageSize = 20,
  }) async {
    Uri url = Uri.parse(
      '$baseUrl/Ingredients?searchTerm=$searchTerm&page=$page&pageSize=$pageSize',
    );

    if (searchTerm == "") {
      url = Uri.parse('$baseUrl/Ingredients?page=$page&pageSize=$pageSize');
    }

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<IngredientResponse> jsonResponse = (data['items'] as List)
            .map(
              (item) =>
                  IngredientResponse.safeFromJson(item as Map<String, dynamic>),
            )
            .whereType<IngredientResponse>()
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

  Future<dynamic> fetchCommonIngredient() async {
    final url = Uri.parse('${baseUrl}/Ingredients/common/allergens');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonResponse = (data as List)
            .map(
              (item) =>
                  IngredientResponse.safeFromJson(item as Map<String, dynamic>),
            )
            .whereType<IngredientResponse>()
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
