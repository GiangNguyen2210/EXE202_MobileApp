import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/firebase_api.dart';

class NotificationAcceptanceScreen extends StatefulWidget {
  const NotificationAcceptanceScreen({super.key});

  @override
  State<NotificationAcceptanceScreen> createState() =>
      _NotificationAcceptanceScreenState();
}

class _NotificationAcceptanceScreenState
    extends State<NotificationAcceptanceScreen> {
  late SignUpRequestDTO signUpRequestDTO;

  late FirebaseService firebaseService;

  @override
  void initState() {
    super.initState();
    firebaseService = FirebaseService();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E2DC), // light pink background
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  const SizedBox(height: 32),
                  const Text(
                    "Allow notifications to reach your goals",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(height: 180, width: 300),
                        Positioned(
                          top: 40,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: 260,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // 🥗 Meal image at the start
                                Image.asset(
                                  'assets/icon.png',
                                  width: 32,
                                  height: 32,
                                ),
                                const SizedBox(width: 8),

                                // ✅ Checkbox icon
                                const Icon(
                                  Icons.check_box,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 8),

                                // 📝 Text content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Have you logged every meal?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Make sure to track your meals for the day",
                                      ),
                                    ],
                                  ),
                                ),

                                // ⏰ Timestamp
                                const Text(
                                  "now",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    "Users who allow reach their goals 62% more often",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text("Eatr would like to send you notifications"),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            NavigationService.pushNamed(
                              '/login',
                              arguments: signUpRequestDTO,
                            );
                          },
                          child: const Text("Don’t allow"),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFECECEC),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            signUpRequestDTO.deviceId = await firebaseService
                                .requestAndSendFCMToken();
                            NavigationService.pushNamed(
                              '/login',
                              arguments: signUpRequestDTO,
                            );
                            print(signUpRequestDTO.toString());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2A38),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Allow"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(bool? completed) {
    Color color;
    if (completed == true) {
      color = Colors.green;
    } else if (completed == false) {
      color = Colors.orange;
    } else {
      color = Colors.grey.shade300;
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
