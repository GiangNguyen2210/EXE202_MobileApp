import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/DTOs/recipe_response.dart';

class RecipeApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = const FlutterSecureStorage();
  static const int _timeoutSeconds = 20;

  Future<RecipeResponse> fetchRecipes({
    required int page,
    required int pageSize,
    String? mealName,
    String? searchTerm, // New: Add searchTerm parameter
  }) async {
    final uri = Uri.parse(
      '$baseUrl/Recipes/home?page=$page&pageSize=$pageSize${mealName != null ? '&category=$mealName' : ''}${searchTerm != null ? '&searchTerm=$searchTerm' : ''}',
    );
    try {
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: _timeoutSeconds));
      if (response.statusCode == 200) {
        return RecipeResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }
}