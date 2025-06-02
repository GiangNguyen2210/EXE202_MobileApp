// lib/services/payos_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/DTOs/payment_request.dart';
import '../models/DTOs/payment_response.dart';

class PayOSService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  Future<PaymentResponse> createPaymentLink(PaymentRequest request, int upId) async {
    final url = Uri.parse('$baseUrl/payment/create?upId=$upId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PaymentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Tạo link thanh toán thất bại: ${response.body}');
    }
  }
}