import 'package:exe202_mobile_app/api/allergies_screen_api.dart';
import 'package:exe202_mobile_app/models/DTOs/sign_up_request.dart';
import 'package:exe202_mobile_app/service/navigate_service.dart';
import 'package:flutter/material.dart';

import '../../service/common_allergens_service.dart';

class AllergySelectionScreen extends StatefulWidget {
  const AllergySelectionScreen({super.key});

  @override
  State<AllergySelectionScreen> createState() => _AllergySelectionScreenState();
}

class _AllergySelectionScreenState extends State<AllergySelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final AllergiesScreenService allergiesScreenService =
      AllergiesScreenService();
  late final AllergensService allergensService;

  late SignUpRequestDTO signUpRequestDTO;

  late List<AllergenItem> allergens = [];

  final TextEditingController _textController = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  Future<void> loadIngredient() async {
    final jsonResponse = await allergiesScreenService.fetchCommonIngredient();
    final parsedIngredients = allergensService.parseIngredientToAllergenList(
      jsonResponse,
    );

    setState(() {
      allergens = parsedIngredients;
    });
  }

  @override
  void initState() {
    super.initState();
    allergensService = AllergensService();
    loadIngredient();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Retrieve the passed argument
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is SignUpRequestDTO) {
      signUpRequestDTO = args;
      signUpRequestDTO.listAllergies = [];
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

  final List<AllergenItem> selectedAllergies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              const Text(
                "Allergies",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "What foods are you allergic to?",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Search bar (non-functional)
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "All allergens",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (selectedAllergies.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected allergens",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedAllergies.map((al) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                al.name,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedAllergies.remove(al);
                                    signUpRequestDTO.listAllergies?.remove(
                                      al.id,
                                    );
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              const Text(
                "Common allergens",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Allergen grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3.8,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: allergens
                      .where(
                        (allergen) => !selectedAllergies.contains(allergen),
                      )
                      .map((allergen) {
                        final selected = selectedAllergies.contains(allergen);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selected) {
                                selectedAllergies.remove(allergen);
                                signUpRequestDTO.listAllergies?.remove(
                                  allergen.id,
                                );
                              } else {
                                selectedAllergies.add(allergen);
                                signUpRequestDTO.listAllergies?.add(
                                  allergen.id,
                                );
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: selected ? Colors.black87 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? Colors.black87
                                    : Colors.black12,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  allergen.icon,
                                  size: 20,
                                  color: selected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  allergen.name,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),

              // Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      NavigationService.goBack();
                    },
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NavigationService.pushNamed(
                          'healthconditionselection',
                          arguments: signUpRequestDTO,
                        );
                        print(signUpRequestDTO.toString());
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

class AllergenItem {
  final String name;
  final IconData icon;
  final int id;

  AllergenItem(this.name, this.icon, this.id);
}
