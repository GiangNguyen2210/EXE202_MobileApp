import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

import '../../models/DTOs/sign_up_request.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderState();
}

class _GenderState extends State<GenderScreen>
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

  String selected = "";

  final List<GenderOption> options = [
    GenderOption("Male", Icons.male, Colors.blue),
    GenderOption("Female", Icons.female, Colors.purple),
    GenderOption("Other", Icons.all_inclusive, Colors.orange),
    GenderOption("Prefer not to say", Icons.emoji_emotions, Colors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3C2), // Light yellow
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              const Text(
                "Gender",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "What is your gender? We'll use this information to calculate your daily energy needs",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              ...options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = option.label;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected == option.label
                              ? option.color
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(option.icon, color: option.color),
                              if (selected == option.label)
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.black,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

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
                    onPressed: selected != ""
                        ? () {
                            signUpRequestDTO.gender = selected;
                            NavigationService.pushNamed(
                              'ageselection',
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

class GenderOption {
  final String label;
  final IconData icon;
  final Color color;

  GenderOption(this.label, this.icon, this.color);
}
