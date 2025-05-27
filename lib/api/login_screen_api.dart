import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:exe202_mobile_app/models/DTOs/customer_login_response.dart';
import 'package:exe202_mobile_app/models/DTOs/error_message_reponse.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreenService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = FlutterSecureStorage();

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
        final jsonResponse = CustomerLoginResponse.fromJson(data);

        if (jsonResponse != null && rememberMe) {
          await storage.write(key: 'jwt_token', value: jsonResponse.Token);
          return jsonResponse;
        } else {
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
}
