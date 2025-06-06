import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:exe202_mobile_app/api/profile_api.dart';
import 'ingredients_dropdown_dialog.dart';
import 'health_conditions_dropdown_dialog.dart';

// Profile Avatar Widget
class ProfileAvatar extends StatefulWidget {
  final String? userPicture;
  final int upId;

  const ProfileAvatar({super.key, this.userPicture, required this.upId});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _image;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      try {
        final api = ProfileApi();
        final response = await api.uploadProfileImage(widget.upId, _image!);
        if (response.secureUrl != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image uploaded successfully!'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : widget.userPicture != null && widget.userPicture!.isNotEmpty
                ? NetworkImage(widget.userPicture!) as ImageProvider
                : const AssetImage('assets/default_profile.png') as ImageProvider,
            child: null,
          ),
        ),
        Positioned(
          bottom: -5,
          right: -5,
          child: GestureDetector(
            onTap: _pickAndUploadImage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Profile Name Widget
class ProfileName extends StatelessWidget {
  final String handle;
  final String name;
  final bool isEditing;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;

  const ProfileName({
    required this.handle,
    required this.name,
    required this.isEditing,
    required this.fullNameController,
    required this.usernameController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isEditing
            ? TextField(
          controller: fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        )
            : Text(
          name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        Text(
          handle,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}

// Stat Card Widget
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }
}

// Section Card Widget
class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SectionCard({
    required this.title,
    required this.icon,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

// List Item Widget
class ListItem extends StatelessWidget {
  final String title;
  final Color dotColor;
  final String? subtitle;
  final bool isEditing;
  final TextEditingController? controller;
  final String? titlePrefix;

  const ListItem({
    required this.title,
    required this.dotColor,
    this.subtitle,
    this.isEditing = false,
    this.controller,
    this.titlePrefix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: isEditing
                ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: titlePrefix != null ? titlePrefix!.replaceAll(': ', '') : title,
                border: const OutlineInputBorder(),
              ),
            )
                : Text(
              title,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ),
          if (subtitle != null && !isEditing)
            Text(
              subtitle!,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
        ],
      ),
    );
  }
}

// Save Button Widget
class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          backgroundColor: Colors.blue,
        ),
        child: const Text(
          'SAVE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Allergies Dialog Widget
class AllergiesDialog extends StatefulWidget {
  final List<String> initialAllergies;
  final GlobalKey<NavigatorState> navigatorKey;

  const AllergiesDialog({required this.initialAllergies, required this.navigatorKey, super.key});

  @override
  State<AllergiesDialog> createState() => _AllergiesDialogState();
}

class _AllergiesDialogState extends State<AllergiesDialog> {
  late List<String> _selectedAllergies;

  @override
  void initState() {
    super.initState();
    _selectedAllergies = List.from(widget.initialAllergies);
  }

  @override
  Widget build(BuildContext context) {
    print('Building AllergiesDialog with initial allergies: $_selectedAllergies');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Navigator(
              initialRoute: 'ingredientTypes',
              onGenerateRoute: (settings) {
                if (settings.name == 'ingredientTypes') {
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => _IngredientTypesScreen(
                      selectedAllergies: _selectedAllergies,
                      onAllergiesChanged: (allergies) {
                        setState(() {
                          _selectedAllergies = allergies;
                        });
                      },
                      onClose: () {
                        print('Closing dialog');
                        Navigator.of(widget.navigatorKey.currentContext ?? context).pop();
                      },
                      onSave: () {
                        print('Saving and closing dialog');
                        Navigator.of(widget.navigatorKey.currentContext ?? context).pop(_selectedAllergies);
                      },
                      navigatorKey: widget.navigatorKey,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child; // No transition for initial route
                    },
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientTypesScreen extends StatelessWidget {
  final List<String> selectedAllergies;
  final ValueChanged<List<String>> onAllergiesChanged;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final GlobalKey<NavigatorState> navigatorKey;

  const _IngredientTypesScreen({
    required this.selectedAllergies,
    required this.onAllergiesChanged,
    required this.onClose,
    required this.onSave,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    print('Building _IngredientTypesScreen with selected allergies: $selectedAllergies');
    return Column(
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
              const SizedBox(width: 48), // Space for alignment
              Expanded(
                child: Center(
                  child: Text(
                    'Allergies',
                    style: GoogleFonts.lobster(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  print('X button pressed');
                  onClose();
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
                          selectedAllergies.isEmpty
                              ? 'All products'
                              : selectedAllergies.join(', '),
                          style: TextStyle(
                            color: selectedAllergies.isEmpty ? Colors.grey : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.sd_card_alert, color: Colors.redAccent),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ingredient Types',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: ProfileApi().fetchIngredientTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final ingredientTypes = snapshot.data!;
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: ingredientTypes.map((type) {
                          return ChoiceChip(
                            label: Text(type['typeName']),
                            selected: false,
                            onSelected: (selected) async {
                              final updatedAllergies = await showDialog<List<String>>(
                                context: context,
                                builder: (context) => IngredientsDropdownDialog(
                                  typeId: type['ingredientTypeId'] as int,
                                  typeName: type['typeName'],
                                  initialSelectedAllergies: selectedAllergies,
                                ),
                              );
                              if (updatedAllergies != null) {
                                onAllergiesChanged(updatedAllergies);
                              }
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(child: Text('No ingredient types available'));
                    }
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Confirm button pressed');
                      onSave();
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
    );
  }
}

// Health Conditions Dialog Widget
class HealthConditionsDialog extends StatefulWidget {
  final List<Map<String, dynamic>> initialHealthConditions;
  final GlobalKey<NavigatorState> navigatorKey;

  const HealthConditionsDialog({required this.initialHealthConditions, required this.navigatorKey, super.key});

  @override
  State<HealthConditionsDialog> createState() => _HealthConditionsDialogState();
}

class _HealthConditionsDialogState extends State<HealthConditionsDialog> {
  late List<Map<String, dynamic>> _selectedHealthConditions;

  @override
  void initState() {
    super.initState();
    _selectedHealthConditions = List.from(widget.initialHealthConditions);
  }

  @override
  Widget build(BuildContext context) {
    print('Building HealthConditionsDialog with initial conditions: $_selectedHealthConditions');
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Navigator(
              initialRoute: 'healthConditionTypes',
              onGenerateRoute: (settings) {
                if (settings.name == 'healthConditionTypes') {
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => _HealthConditionTypesScreen(
                      selectedHealthConditions: _selectedHealthConditions,
                      onHealthConditionsChanged: (conditions) {
                        setState(() {
                          _selectedHealthConditions = conditions;
                        });
                      },
                      onClose: () {
                        print('Closing health conditions dialog');
                        Navigator.of(widget.navigatorKey.currentContext ?? context).pop();
                      },
                      onSave: () {
                        print('Saving and closing health conditions dialog');
                        Navigator.of(widget.navigatorKey.currentContext ?? context).pop(_selectedHealthConditions);
                      },
                      navigatorKey: widget.navigatorKey,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return child; // No transition for initial route
                    },
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthConditionTypesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedHealthConditions;
  final ValueChanged<List<Map<String, dynamic>>> onHealthConditionsChanged;
  final VoidCallback onClose;
  final VoidCallback onSave;
  final GlobalKey<NavigatorState> navigatorKey;

  const _HealthConditionTypesScreen({
    required this.selectedHealthConditions,
    required this.onHealthConditionsChanged,
    required this.onClose,
    required this.onSave,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    print('Building _HealthConditionTypesScreen with selected conditions: $selectedHealthConditions');
    return Column(
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
              const SizedBox(width: 48), // Space for alignment
              Expanded(
                child: Center(
                  child: Text(
                    'Health Conditions',
                    style: GoogleFonts.lobster(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  print('X button pressed in health conditions dialog');
                  onClose();
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
                          selectedHealthConditions.isEmpty
                              ? 'No conditions selected'
                              : selectedHealthConditions.map((c) => c['condition']).join(', '),
                          style: TextStyle(
                            color: selectedHealthConditions.isEmpty ? Colors.grey : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Icon(Icons.search, color: Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Health Condition Types',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<String>>(
                  future: ProfileApi().fetchHealthConditionTypes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final conditionTypes = snapshot.data!;
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: conditionTypes.map((type) {
                          return ChoiceChip(
                            label: Text(type),
                            selected: false,
                            onSelected: (selected) async {
                              final updatedConditions = await showDialog<List<Map<String, dynamic>>>(
                                context: context,
                                builder: (context) => HealthConditionsDropdownDialog(
                                  typeName: type,
                                  initialSelectedHealthConditions: selectedHealthConditions,
                                ),
                              );
                              if (updatedConditions != null) {
                                onHealthConditionsChanged(updatedConditions);
                              }
                            },
                            selectedColor: Colors.blue.withOpacity(0.2),
                            backgroundColor: Colors.grey[200],
                          );
                        }).toList(),
                      );
                    } else {
                      return const Center(child: Text('No condition types available'));
                    }
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      print('Confirm button pressed in health conditions dialog');
                      onSave();
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
    );
  }
}