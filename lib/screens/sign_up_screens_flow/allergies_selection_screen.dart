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

  SignUpRequestDTO signUpRequestDTO = SignUpRequestDTO(
    mealScheduledDTO: MealScheduledDTO(),
  );

  late List<AllergenItem> allergens = [];

  final TextEditingController _textController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final List<AllergenItem> selectedAllergies = [];
  List<AllergenItem> suggestions = [];

  void _showOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    // ❗️Filter out already selected items
    final filteredSuggestions = suggestions
        .where((item) => !selectedAllergies.contains(item))
        .toList();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 48,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 55),
          showWhenUnlinked: false,
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50, maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final item = filteredSuggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(item.name),
                    onTap: () {
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                      FocusScope.of(context).unfocus();
                      setState(() {
                        selectedAllergies.add(item);
                        signUpRequestDTO.listAllergies.add(item.id);
                        _textController.clear();
                        suggestions.clear();
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

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
    } else {
      // Handle null or wrong type
      throw Exception("Missing or invalid arguments for ABitAboutYoursScreen");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
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

              CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: _textController,
                  onTap: () async {
                    final json = await allergiesScreenService.fetchIngredients(
                      searchTerm: "",
                      page: 1,
                      pageSize: 10,
                    );
                    final parsed = allergensService
                        .parseIngredientToAllergenList(json);
                    setState(() => suggestions = parsed);
                    _showOverlay();
                  },
                  onSubmitted: (value) async {
                    if (value.trim().isNotEmpty) {
                      final json = await allergiesScreenService
                          .fetchIngredients(
                            searchTerm: value.trim(),
                            page: 1,
                            pageSize: 10,
                          );
                      final parsed = allergensService
                          .parseIngredientToAllergenList(json);
                      setState(() => suggestions = parsed);
                      _showOverlay();
                    }
                  },
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
              ),

              const SizedBox(height: 24),

              if (selectedAllergies.isNotEmpty) ...[
                const Text(
                  "Selected allergens",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                ),
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 120),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedAllergies.map((al) {
                        return ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 250),
                          child: Container(
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
                                Expanded(
                                  child: Text(
                                    al.name,
                                    style: const TextStyle(color: Colors.white),
                                    softWrap: true,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedAllergies.remove(al);
                                      signUpRequestDTO.listAllergies.remove(
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
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              const Text(
                "Common allergens",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: allergens
                    .where((a) => !selectedAllergies.contains(a))
                    .map((allergen) {
                      final selected = selectedAllergies.contains(allergen);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              selectedAllergies.remove(allergen);
                              signUpRequestDTO.listAllergies.remove(
                                allergen.id,
                              );
                            } else {
                              selectedAllergies.add(allergen);
                              signUpRequestDTO.listAllergies.add(allergen.id);
                            }
                          });
                        },
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 180),
                          // optional
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: selected ? Colors.black87 : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? Colors.black87 : Colors.black26,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                allergen.icon,
                                size: 20,
                                color: selected ? Colors.white : Colors.black87,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  allergen.name,
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: selected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  IconButton(
                    onPressed: () => NavigationService.goBack(),
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
                        debugPrint(signUpRequestDTO.toString());
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

class AllergenItem {
  final String name;
  final IconData icon;
  final int id;

  AllergenItem(this.name, this.icon, this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AllergenItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
