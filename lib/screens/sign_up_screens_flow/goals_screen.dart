import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/goals_service.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/api/goals_screen_api.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final GoalsScreenService goalsScreenService;
  late final GoalsService goalsService;
  late SignUpRequestDTO signUpRequestDTO;
  List<GoalData> goals = [];
  int? selectedGoalTitle;

  Future<void> loadGoals() async {
    final jsonResponse = await goalsScreenService.fetchGoals();
    final parsedGoals = goalsService.parseGoalsToGoalDataList(jsonResponse);

    setState(() {
      goals = parsedGoals;
    });

    _controller.forward(); // Start animation
  }

  @override
  void initState() {
    super.initState();
    goalsScreenService = GoalsScreenService();
    goalsService = GoalsService();
    signUpRequestDTO = SignUpRequestDTO(mealScheduledDTO: MealScheduledDTO());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    loadGoals();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6E8CC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Choose Your Goal",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Select what matters most to you right now",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: goals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;

                    final animation = CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        (index / goals.length).clamp(0.0, 1.0),
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    );

                    return FadeTransition(
                      opacity: animation,
                      child: GoalCard(
                        data: goal,
                        isSelected:
                            selectedGoalTitle ==
                            int.parse(goal.subtitle.split(":")[1]),

                        onTap: () {
                          setState(() {
                            selectedGoalTitle = int.parse(
                              goal.subtitle.split(":")[1],
                            );
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      NavigationService.goBack();
                    },
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: selectedGoalTitle != null
                        ? () {
                            signUpRequestDTO.goalId = selectedGoalTitle;
                            NavigationService.pushNamed(
                              'abitaboutyour',
                              arguments: signUpRequestDTO,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalData {
  final String title;
  final String subtitle;
  final IconData icon;

  GoalData(this.title, this.subtitle, this.icon);
}

class GoalCard extends StatelessWidget {
  final GoalData data;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.teal : Colors.transparent,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(data.icon, size: 28, color: Colors.black87),
            const SizedBox(height: 16),
            Text(
              data.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
