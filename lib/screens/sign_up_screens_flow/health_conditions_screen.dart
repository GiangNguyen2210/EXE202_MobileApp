import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

import '../../api/allergies_screen_api.dart';
import '../../api/health_conditions_api.dart';
import '../../service/health_conditions_service.dart';

class HealthConditionScreen extends StatefulWidget {
  const HealthConditionScreen({super.key});

  @override
  State<HealthConditionScreen> createState() => _HealthConditionScreenState();
}

class _HealthConditionScreenState extends State<HealthConditionScreen> {
  late HealthConditionsApi healthConditionsApi;
  late HCService hcService;
  List<HCItem> items = []; // initialize empty list
  late SignUpRequestDTO signUpRequestDTO;

  Future<void> loadHealthCondition() async {
    final jsonResponse = await healthConditionsApi.fetchHealthConditions();
    final parsedItems = hcService.parseResponseToHCItem(jsonResponse);

    setState(() {
      items = parsedItems;
    });
  }

  @override
  void initState() {
    super.initState();
    healthConditionsApi = HealthConditionsApi();
    hcService = HCService();
    loadHealthCondition();
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Text(
                "Select your health conditions",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final hcItem = items[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hcItem.hcname ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Health condition description here...',
                                  // Optional
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: hcItem.a,
                            onChanged: (val) {
                              setState(() {
                                hcItem.a = val;
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "This information helps us provide personalized health recommendations",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NavigationService.goBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final selected = items
                            .where((item) => item.a)
                            .map((item) => item.id)
                            .toList();
                        signUpRequestDTO.listHConditions = selected;
                        NavigationService.pushNamed(
                          'notiacceptance',
                          arguments: signUpRequestDTO,
                        );
                        print(signUpRequestDTO.toString());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9B57F3),
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
