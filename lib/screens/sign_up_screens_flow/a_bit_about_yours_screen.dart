import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

class ABitAboutYoursScreen extends StatefulWidget {
  const ABitAboutYoursScreen({super.key});

  @override
  State<ABitAboutYoursScreen> createState() => _ABitAboutYoursState();
}

class _ABitAboutYoursState extends State<ABitAboutYoursScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late SignUpRequestDTO signUpRequestDTO;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the passed argument
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is SignUpRequestDTO) {
      signUpRequestDTO = args;
    } else {
      // Handle null or wrong type
      throw Exception("Missing or invalid arguments for ABitAboutYoursScreen");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE16B), Color(0xFFFFD447)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                const Text(
                  "A Bit About Your\nBody",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Your age, weight, and other details will help us create a more personalized plan",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const Spacer(),

                // Bottom row
                Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        NavigationService.goBack();
                      },
                    ),
                    const Spacer(),

                    // Continue button
                    ElevatedButton(
                      onPressed: () {
                        NavigationService.pushNamed(
                          'genderselection',
                          arguments: signUpRequestDTO,
                        );
                      },
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
                      child: const Text(
                        "Let's Do This!",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
