import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

class WeightSelectionScreen extends StatefulWidget {
  const WeightSelectionScreen({super.key});

  @override
  State<WeightSelectionScreen> createState() => WeightSelectionScreenState();
}

class WeightSelectionScreenState extends State<WeightSelectionScreen> {
  final ScrollController _scrollController = ScrollController();
  final double tickWidth = 20.0;
  final int minWeight = 0;
  final int maxWeight = 1000;
  late int selectedWeight;
  late SignUpRequestDTO signUpRequestDTO;

  @override
  void initState() {
    super.initState();
    selectedWeight = 45;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo((selectedWeight - minWeight) * tickWidth);
    });

    _scrollController.addListener(() {
      final index = (_scrollController.offset / tickWidth).round();
      final newWeight = (minWeight + index).clamp(minWeight, maxWeight);
      if (newWeight != selectedWeight) {
        setState(() {
          selectedWeight = newWeight;
        });
      }
    });
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
  Widget build(BuildContext context) {
    final tickCount = maxWeight - minWeight + 1;

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
                "Goal Weight",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "What is your goal weight?",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              const SizedBox(height: 24),

              // Weight Selector
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCB66),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Weight input and scroll scale
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedWeight.toString(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(" Kg"),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(
                          height: 60,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: tickCount,
                                itemBuilder: (context, index) {
                                  final weight = minWeight + index;
                                  final isMajor = weight % 5 == 0;

                                  return SizedBox(
                                    width: tickWidth,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: isMajor ? 24 : 16,
                                          width: 2,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 3,
                                  height: 60,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom buttons
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
                        signUpRequestDTO.weight = selectedWeight;
                        NavigationService.pushNamed(
                          'goalweightselection',
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
}
