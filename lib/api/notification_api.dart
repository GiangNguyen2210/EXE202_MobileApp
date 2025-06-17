import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/DTOs/notification_response.dart';

class NotificationApi {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  static const int _timeoutSeconds = 20;

  NotificationApi() {
    print('Base URL: $baseUrl'); // Debug
  }

  Future<NotificationResponse> fetchNotifications({
    int page = 1,
    int pageSize = 10,
    String? searchTerm,
    String? typeFilter,
    String? sortColumn,
    String? sortOrder,
  }) async {
    if (page < 1) page = 1; // Đảm bảo page hợp lệ
    final uri = Uri.parse('$baseUrl/Notifications').replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        if (searchTerm != null) 'searchTerm': searchTerm,
        if (typeFilter != null) 'typeFilter': typeFilter,
        if (sortColumn != null) 'sortColumn': sortColumn,
        if (sortOrder != null) 'sortOrder': sortOrder,
      },
    );

    print('Request URL: $uri'); // Debug

    try {
      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          // Thêm Authorization nếu cần:
          // 'Authorization': 'Bearer your_token_here',
        },
      ).timeout(Duration(seconds: _timeoutSeconds));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Response JSON: $jsonData'); // Debug
        return NotificationResponse.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception('Failed to load notifications: ${response.statusCode}, ${errorData['Message'] ?? errorData}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}