import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

class DefinesYourGoalsScreen extends StatefulWidget {
  const DefinesYourGoalsScreen({super.key});

  @override
  State<DefinesYourGoalsScreen> createState() => _DefinesYourGoalsState();
}

class _DefinesYourGoalsState extends State<DefinesYourGoalsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6E8CC), // Mint green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Title
              const Text(
                "Define\nYour Goal",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle
              const Text(
                "Let's get started! Choose your main goal to reach results faster and stay motivated",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const Spacer(),

              // Buttons
              Row(
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      NavigationService.goBack();
                    },
                  ),
                  const Spacer(),

                  // Continue Button
                  ElevatedButton(
                    onPressed: () {
                      NavigationService.pushNamed(
                        'selectgoals',
                        arguments: null,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Dive In!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
