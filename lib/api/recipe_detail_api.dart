import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/DTOs/recipe_detail_modal.dart';

class RecipeDetailApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = const FlutterSecureStorage();

  // RecipeDetailApi(this._apiPath);

  Future<RecipeDetail> fetchRecipeDetail(int recipeId) async {
    final response = await http.get(Uri.parse('$baseUrl/Recipes/${53}'));

    if (response.statusCode == 200) {
      return RecipeDetail.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load recipe detail');
    }
  }
}