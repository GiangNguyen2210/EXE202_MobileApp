import 'dart:convert';
import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:exe202_mobile_app/models/DTOs/customer_login_response.dart';
import 'package:exe202_mobile_app/models/DTOs/error_message_reponse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class LoginScreenService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    // Chỉ set clientId cho Web
    clientId: kIsWeb
        ? '796960183009-vosafrdohh3ponoetbbc0ielh8f42kbu.apps.googleusercontent.com'
        : null,
    // Chỉ set serverClientId cho Mobile
    serverClientId: !kIsWeb
        ? '796960183009-vosafrdohh3ponoetbbc0ielh8f42kbu.apps.googleusercontent.com'
        : null,
  );

  Future<dynamic> login(String email, String password, bool rememberMe) async {
    final url = Uri.parse('$baseUrl/Auth/customer/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonResponse = CustomerLoginResponse.safeFromJson(data);

        if (jsonResponse != null && rememberMe) {
          await storage.write(key: 'jwt_token', value: jsonResponse.Token);
          await storage.write(key: 'UPId', value: jsonResponse.UPId.toString());
          return jsonResponse;
        } else if (jsonResponse != null) {
          return jsonResponse;
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

  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication auth = await account!.authentication;

    final idToken = auth.idToken;
    print("idToken : $idToken");
    final url = Uri.parse('$baseUrl/Auth/google');

    try {
      // Send this token to your backend
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '{"idToken":"$idToken"}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonResponse = CustomerLoginResponse.safeFromJson(data);

        if (jsonResponse != null) {
          await storage.write(key: 'jwt_token', value: jsonResponse.Token);
          await storage.write(key: 'UPId', value: jsonResponse.UPId.toString());
          return jsonResponse;
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

  Future<dynamic> signUp(SignUpRequestDTO dto) async {
    final url = Uri.parse('$baseUrl/Auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonResponse = CustomerLoginResponse.safeFromJson(data);

        if (jsonResponse != null) {
          await storage.write(key: 'jwt_token', value: jsonResponse.Token);
          await storage.write(key: 'UPId', value: jsonResponse.UPId.toString());
          print("${await storage.read(key: 'jwt_token')}");
          return jsonResponse;
        } else {
          final data = jsonDecode(response.body);
          final errorResponse = ErrorMessageResponse.fromJson(data);

          return errorResponse;
        }
      }
    } catch (e) {
      throw Exception(")>!ERROR!<( : ${e.toString()}");
      return null;
    }
  }
}
