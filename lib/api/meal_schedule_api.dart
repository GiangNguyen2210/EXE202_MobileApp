import 'dart:convert';

import 'package:exe202_mobile_app/models/DTOs/meal_schedule_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;

import '../models/DTOs/error_message_reponse.dart';
import '../service/meal_schedule_service.dart';

class MealScheduleService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final storage = FlutterSecureStorage();

  Future<dynamic> get(String UPId) async {
    tz.initializeTimeZones();

    await NotificationService().init(); // Your plugin setup
    final url = Uri.parse('$baseUrl/MealCatagories/${UPId}');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jsonResponse = MealSchedule.fromJson(data);

        if (jsonResponse != null) {
          await storage.write(
            key: 'mealTimesSavedAt',
            value: DateTime.now().toIso8601String(),
          );
          await storage.write(
            key: 'breakfastTime',
            value: jsonResponse.breakfastTime.toString(),
          );
          print(jsonResponse.breakfastTime.toString());
          await storage.write(
            key: 'lunchTime',
            value: jsonResponse.lunchTime.toString(),
          );
          print(jsonResponse.lunchTime.toString());
          await storage.write(
            key: 'dinnerTime',
            value: jsonResponse.dinnerTime.toString(),
          );
          print(
            'ne  ===================================================================================  ${jsonResponse.dinnerTime.toString()}',
          );

          final notificationService = NotificationService();

          await notificationService.scheduleDailyNotification(
            id: 1,
            title: 'Time for Breakfast!',
            body: 'Start your day with a healthy meal 🍳',
            time: TimeOfDay(
              hour: jsonResponse.breakfastTime.hour,
              minute: jsonResponse.breakfastTime.minute,
            ),
          );

          await notificationService.scheduleDailyNotification(
            id: 2,
            title: 'Time for Lunch!',
            body: 'Enjoy your lunch break 🥗',
            time: TimeOfDay(
              hour: jsonResponse.lunchTime.hour,
              minute: jsonResponse.lunchTime.minute,
            ),
          );

          await notificationService.scheduleDailyNotification(
            id: 3,
            title: 'Time for Dinner!',
            body: 'Dinner time! Recharge and relax 🍲',
            time: TimeOfDay(
              hour: jsonResponse.dinnerTime.hour,
              minute: jsonResponse.dinnerTime.minute,
            ),
          );

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
