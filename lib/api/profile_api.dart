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

  Future<void> updateUserProfile(UserProfileResponse profile) async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.put(
      Uri.parse('$baseUrl/UserProfile/userProfile/${profile.upId}'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'uPId': profile.upId,
        'fullName': profile.fullName,
        'username': profile.username,
        'age': profile.age,
        'gender': profile.gender,
        'allergies': profile.allergies,
        'healthConditions': profile.healthConditions,
        'userId': profile.userId,
        'email': profile.email,
        'role': profile.role,
        'userPicture': profile.userPicture,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<String>> fetchIngredientTypes() async {
    final String? token = await storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$baseUrl/ingredientTypes'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load ingredient types: ${response.statusCode} - ${response.body}');
    }
  }
}