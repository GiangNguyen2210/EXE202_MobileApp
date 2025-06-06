import 'dart:math';
import 'package:exe202_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:exe202_mobile_app/widgets/login_screen_widgets/login_screen_widgets.dart';

import '../../service/navigate_service.dart';

class LoginOrSignScreen extends StatefulWidget {
  const LoginOrSignScreen({super.key});

  @override
  State<LoginOrSignScreen> createState() => _LoginOrSignScreenState();
}

class _LoginOrSignScreenState extends State<LoginOrSignScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<(String, Color)> iconData = [
    ("❤️", Colors.tealAccent),
    ("🐝", Colors.yellow.shade300),
    ("🍃", Colors.tealAccent),
    ("💪", Colors.yellow.shade300),
    ("🥦", Colors.tealAccent),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconData = [
      ("❤️", Colors.tealAccent),
      ("🐝", Colors.yellow.shade300),
      ("🍃", Colors.tealAccent),
      ("💪", Colors.yellow.shade300),
      ("🥦", Colors.tealAccent),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // Radial Icon Cluster
            SizedBox(
              height: 260,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final center = Offset(constraints.maxWidth / 2, 130);
                  final radius = 100.0;

                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          for (int i = 0; i < iconData.length; i++)
                            radialIcon(
                              angle:
                                  _controller.value * 2 * pi +
                                  i * (2 * pi / iconData.length),
                              radius: radius,
                              emoji: iconData[i].$1,
                              color: iconData[i].$2,
                              center: center,
                            ),
                          // Center icon
                          Positioned(
                            left: center.dx - 50,
                            top: center.dy - 50,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.restaurant_menu,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              "Welcome to App Chảo",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            const Text(
              "Your personal nutrition companion for\nhealthier living",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: () {
                  NavigationService.pushNamed(
                    '/knowyourgoals',
                    arguments: null,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Start Your Journey',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                NavigationService.pushNamed('/login', arguments: null);
              },
              child: const Text(
                "I already have an account",
                style: TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Returns a Positioned emoji icon in a circular layout around center.
  Widget radialIcon({
    required double angle,
    required double radius,
    required String emoji,
    required Color color,
    required Offset center,
  }) {
    final dx = center.dx + radius * cos(angle);
    final dy = center.dy + radius * sin(angle);

    return Positioned(
      left: dx - 24,
      top: dy - 24,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
      ),
    );
  }
}
