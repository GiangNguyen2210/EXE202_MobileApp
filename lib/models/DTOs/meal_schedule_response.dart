import 'package:flutter/material.dart';

class MealSchedule {
  final int upId;
  final TimeOfDay breakfastTime;
  final TimeOfDay lunchTime;
  final TimeOfDay dinnerTime;

  MealSchedule({
    required this.upId,
    required this.breakfastTime,
    required this.lunchTime,
    required this.dinnerTime,
  });

  factory MealSchedule.fromJson(Map<String, dynamic> json) {
    return MealSchedule(
      upId: json['upId'],
      breakfastTime: _parseTimeOfDay(json['breakfastTime']),
      lunchTime: _parseTimeOfDay(json['lunchTime']),
      dinnerTime: _parseTimeOfDay(json['dinnerTime']),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
