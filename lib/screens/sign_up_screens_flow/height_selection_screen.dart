import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

class HeightSelectionScreen extends StatefulWidget {
  const HeightSelectionScreen({super.key});

  @override
  State<HeightSelectionScreen> createState() => _HeightSelectionScreenState();
}

class _HeightSelectionScreenState extends State<HeightSelectionScreen> {
  double heightCm = 177;
  late SignUpRequestDTO signUpRequestDTO;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Text(
                "Height",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "How tall are you?",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // Height Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "${heightCm.round()}",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(" Cm", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 18),
                ],
              ),

              const SizedBox(height: 16),

              // Vertical Slider
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 24,
                      top: 0,
                      bottom: 0,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Slider(
                          value: heightCm,
                          onChanged: (val) => setState(() => heightCm = val),
                          min: 100,
                          max: 220,
                          divisions: 120,
                          activeColor: Colors.black87,
                          inactiveColor: Colors.black26,
                        ),
                      ),
                    ),

                    // Vertical guide labels
                    Positioned(
                      right: 24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var h in [180, 170, 160])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                "$h",
                                style: const TextStyle(
                                  color: Colors.black26,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Body figure
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFCB66),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 150,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCB66),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Bottom Buttons
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      NavigationService.goBack();
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        signUpRequestDTO.height = heightCm;
                        NavigationService.pushNamed(
                          'weightselection',
                          arguments: signUpRequestDTO,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Next"),
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

  Widget _progressSegment(Color color) {
    return Expanded(
      child: Container(
        height: 6,
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
