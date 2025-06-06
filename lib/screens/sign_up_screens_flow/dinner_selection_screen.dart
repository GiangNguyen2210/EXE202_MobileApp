import 'package:flutter/material.dart';

import '../../models/DTOs/sign_up_request.dart';
import '../../service/navigate_service.dart';

class DinnerTimeScreen extends StatefulWidget {
  const DinnerTimeScreen({super.key});

  @override
  State<DinnerTimeScreen> createState() => _DinnerTimeScreenState();
}

class _DinnerTimeScreenState extends State<DinnerTimeScreen> {
  final FixedExtentScrollController hourController =
      FixedExtentScrollController(initialItem: 5); // 6 PM
  final FixedExtentScrollController minuteController =
      FixedExtentScrollController(initialItem: 0);
  final FixedExtentScrollController periodController =
      FixedExtentScrollController(initialItem: 1); // PM

  late SignUpRequestDTO signUpRequestDTO;

  int selectedHour = 6;
  int selectedMinute = 0;
  String period = 'PM';

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
      backgroundColor: const Color(0xFFFDEAE7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress bar
              const SizedBox(height: 24),
              const Text(
                "Dinner time",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "What’s your usual time for dinner?",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),

              // Time picker with highlight
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Highlight box behind text
                    Positioned(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Scroll Pickers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DropletMarker(),
                        const SizedBox(width: 8),

                        // Hours
                        SizedBox(
                          width: 60,
                          child: ListWheelScrollView.useDelegate(
                            controller: hourController,
                            itemExtent: 50,
                            onSelectedItemChanged: (index) {
                              setState(() => selectedHour = index + 1);
                            },
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 12,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    (index + 1).toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const Text(":", style: TextStyle(fontSize: 24)),

                        // Minutes
                        SizedBox(
                          width: 60,
                          child: ListWheelScrollView.useDelegate(
                            controller: minuteController,
                            itemExtent: 50,
                            onSelectedItemChanged: (index) {
                              setState(() => selectedMinute = index);
                            },
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // AM/PM
                        SizedBox(
                          width: 60,
                          child: ListWheelScrollView.useDelegate(
                            controller: periodController,
                            itemExtent: 50,
                            onSelectedItemChanged: (index) {
                              setState(() => period = index == 0 ? 'AM' : 'PM');
                            },
                            physics: const FixedExtentScrollPhysics(),
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 2,
                              builder: (context, index) {
                                final label = index == 0 ? 'AM' : 'PM';
                                return Center(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: SizedBox(
                  height: 4,
                  width: 60,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

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
                        signUpRequestDTO.mealScheduledDTO.DinnerTime =
                            "${selectedHour}:${selectedMinute} ${period}";
                        NavigationService.pushNamed(
                          'allergiesselection',
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

// DropletMarker reused
class DropletMarker extends StatelessWidget {
  const DropletMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(20, 24), painter: _DropletPainter());
  }
}

class _DropletPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1F2C3B);
    final path = Path()
      ..moveTo(size.width, size.height / 2)
      ..quadraticBezierTo(0, 0, 0, size.height / 2)
      ..quadraticBezierTo(0, size.height, size.width, size.height / 2)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
