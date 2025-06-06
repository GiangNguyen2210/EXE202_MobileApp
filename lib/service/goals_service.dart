import 'package:flutter/material.dart';

import '../models/DTOs/sign_up_request.dart';
import '../screens/sign_up_screens_flow/goals_screen.dart';

class GoalsService {
  IconData _getIconForGoal(int goalId, String goalName) {
    switch (goalId) {
      case 1:
        return Icons.restaurant;
      case 2:
        return Icons.school;
      case 3:
        return Icons.fitness_center;
      case 4:
        return Icons.monitor_weight;
      case 5:
        return Icons.auto_awesome;
      case 6:
        return Icons.assignment_turned_in;
      case 7:
        return Icons.sports_mma;
      case 8:
        return Icons.timer;
      default:
        return Icons.help_outline;
    }
  }

  GoalData mapGoalToGoalData(GoalsResponseDTO dto) {
    final String goalName = dto.goalName ?? 'Unknown Goal';
    final int goalId = dto.goalId ?? 0;

    final subtitle = "ID: $goalId";
    final icon = _getIconForGoal(goalId, goalName);

    return GoalData(goalName, subtitle, icon);
  }

  List<GoalData> parseGoalsToGoalDataList(List<GoalsResponseDTO> dtoList) {
    return dtoList.map((dto) => mapGoalToGoalData(dto)).toList();
  }
}
