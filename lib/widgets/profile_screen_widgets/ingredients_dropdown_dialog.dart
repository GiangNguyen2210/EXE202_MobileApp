import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:exe202_mobile_app/api/profile_api.dart';

class IngredientsDropdownDialog extends StatefulWidget {
  final int typeId;
  final String typeName;
  final List<String> initialSelectedAllergies;

  const IngredientsDropdownDialog({
    required this.typeId,
    required this.typeName,
    required this.initialSelectedAllergies,
    super.key,
  });

  @override
  State<IngredientsDropdownDialog> createState() => _IngredientsDropdownDialogState();
}

class _IngredientsDropdownDialogState extends State<IngredientsDropdownDialog> {
  late List<String> _selectedAllergies;

  @override
  void initState() {
    super.initState();
    _selectedAllergies = List.from(widget.initialSelectedAllergies);
  }

  void _toggleAllergy(String ingredient) {
    setState(() {
      if (_selectedAllergies.contains(ingredient)) {
        _selectedAllergies.remove(ingredient);
      } else {
        _selectedAllergies.add(ingredient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orangeAccent, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.typeName,
                        style: GoogleFonts.lobster(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context); // Close without saving
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedAllergies.isEmpty
                                  ? 'No allergies selected'
                                  : _selectedAllergies.join(', '),
                              style: TextStyle(
                                color: _selectedAllergies.isEmpty ? Colors.grey : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ingredients in ${widget.typeName}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<List<String>>(
                      future: ProfileApi().fetchIngredientsByType(widget.typeId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final ingredients = snapshot.data!;
                          return SizedBox(
                            height: 200, // Constrain height for scrolling
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: ingredients.length,
                              itemBuilder: (context, index) {
                                final ingredient = ingredients[index];
                                final isSelected = _selectedAllergies.contains(ingredient);
                                return ListTile(
                                  title: Text(ingredient),
                                  trailing: isSelected
                                      ? const Icon(Icons.check, color: Colors.blue)
                                      : null,
                                  tileColor: isSelected ? Colors.blue.withOpacity(0.2) : null,
                                  onTap: () => _toggleAllergy(ingredient),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(child: Text('No ingredients available'));
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, _selectedAllergies); // Save selected allergies
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}