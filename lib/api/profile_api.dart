import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../models/DTOs/user_profile_response.dart';
import '../models/DTOs/profile_image_response_dto.dart';

class ProfileApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = FlutterSecureStorage();

  Future<UserProfileResponse> fetchUserProfile(int upId) async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/UserProfile/userProfile/$upId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile: ${response.statusCode} - ${response.body}');
    }
  }

  Future<ProfileImageResponseDTO> uploadProfileImage(int upId, File imageFile) async {
    final String? token = await storage.read(key: 'jwt_token');
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/uploadProfileImage'))
      ..fields['upId'] = upId.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', imageFile.path.split('.').last),
      ))
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        if (token != null) 'Authorization': 'Bearer $token',
      });

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return ProfileImageResponseDTO.fromJson(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to upload profile image: ${response.statusCode} - $responseBody');
    }
  }

  Future<UserProfileResponse> updateUserProfile(UserProfileResponse profile) async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.put(
      Uri.parse('$baseUrl/UserProfile/${1}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profile.toJson()), // Use toJson method
    );
    if (response.statusCode == 200) {
      return UserProfileResponse.fromJson(jsonDecode(response.body)); // Return the updated profile
    } else {
      throw Exception('Failed to update user profile: ${response.statusCode}-${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchIngredientTypes() async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/Ingredients/ingredient-types'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => {
        'ingredientTypeId': item['ingredientTypeId'] as int,
        'typeName': item['typeName'] as String,
      }).toList();
    } else {
      throw Exception('Failed to load ingredient types: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<String>> fetchIngredientsByType(int ingredientTypeId) async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/Ingredients/ingredients?typeId=$ingredientTypeId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => item['ingredientName'] as String).toList();
    } else {
      throw Exception('Failed to load ingredients: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<String>> fetchHealthConditionTypes() async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/HealthCondition/health-condition-types'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => item as String).toList();
    } else {
      throw Exception('Failed to load health condition types: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchHealthConditionsByType(String healthConditionType) async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/HealthCondition/health-conditions?type=$healthConditionType'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items.map((item) => {
        'healthConditionId': item['healthConditionId'] as int,
        'healthConditionName': item['healthConditionName'] as String,
        'briefDescription': item['briefDescription'] as String,
      }).toList();
    } else {
      throw Exception('Failed to load health conditions: ${response.statusCode} - ${response.body}');
    }
  }
}