import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/profile_api.dart';
import '../models/DTOs/user_profile_response.dart';
import '../widgets/profile_screen_widgets/profile_screen_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const ProfileScreen({super.key, required this.navigatorKey});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfileResponse> _userProfileFuture;
  bool _isEditing = false;
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  int? _selectedAge;
  String? _selectedGender;
  late TextEditingController _emailController;
  List<TextEditingController> _allergyControllers = [];
  List<TextEditingController> _conditionControllers = [];
  List<String> _selectedAllergies = [];
  List<Map<String, dynamic>> _selectedHealthConditions = [];

  @override
  void initState() {
    super.initState();
    print('Fetching user profile...');
    _userProfileFuture = ProfileApi().fetchUserProfile(1).then((profile) {
      _selectedAge = profile.age;
      _selectedGender = profile.gender;
      _selectedAllergies = List.from(profile.allergies ?? []);
      _selectedHealthConditions = profile.healthConditions.isNotEmpty
          ? profile.healthConditions.map((hc) => {'condition': hc.condition, 'status': hc.status}).toList()
          : [];
      print('Initial health conditions from API: $_selectedHealthConditions');
      return profile;
    });
  }

  @override
  void dispose() {
    _fullNameController?.dispose();
    _usernameController?.dispose();
    _emailController?.dispose();
    for (var controller in _allergyControllers) {
      controller.dispose();
    }
    for (var controller in _conditionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _userProfileFuture = ProfileApi().fetchUserProfile(1).then((profile) {
          _selectedAge = profile.age;
          _selectedGender = profile.gender;
          _selectedAllergies = List.from(profile.allergies ?? []);
          _selectedHealthConditions = profile.healthConditions.isNotEmpty
              ? profile.healthConditions.map((hc) => {'condition': hc.condition, 'status': hc.status}).toList()
              : [];
          print('Reset health conditions: $_selectedHealthConditions');
          return profile;
        });
      }
    });
  }

  void _saveProfile(UserProfileResponse userProfile) async {
    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full Name cannot be empty')),
      );
      return;
    }

    final emailPattern = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!_emailController.text.trim().isEmpty && !emailPattern.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    try {
      final updatedProfile = UserProfileResponse(
        upId: userProfile.upId,
        fullName: _fullNameController.text,
        username: _usernameController.text.isEmpty ? null : _usernameController.text,
        age: _selectedAge ?? userProfile.age,
        gender: _selectedGender ?? userProfile.gender ?? '',
        allergies: _selectedAllergies,
        healthConditions: _selectedHealthConditions.map((hc) => HealthCondition(condition: hc['condition'] ?? '', status: hc['status'])).toList(),
        userId: userProfile.userId,
        email: _emailController.text,
        role: userProfile.role,
        userPicture: userProfile.userPicture,
      );

      print('Sending profile update with age: ${updatedProfile.age}, gender: ${updatedProfile.gender}');

      final serverUpdatedProfile = await ProfileApi().updateUserProfile(updatedProfile);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      print('Received updated profile from server: age: ${serverUpdatedProfile.age}, gender: ${serverUpdatedProfile.gender}');
      setState(() {
        _isEditing = false;
        _userProfileFuture = Future.value(serverUpdatedProfile);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> _showAllergiesDialog(BuildContext context, List<String> initialAllergies) async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AllergiesDialog(
        initialAllergies: initialAllergies,
        navigatorKey: widget.navigatorKey,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedAllergies = result;
      });
    }
  }

  Future<void> _showHealthConditionsDialog(BuildContext context, List<Map<String, dynamic>> initialHealthConditions) async {
    final result = await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) => HealthConditionsDialog(
        initialHealthConditions: initialHealthConditions,
        navigatorKey: widget.navigatorKey,
      ),
    );

    if (result != null) {
      print('Received health conditions from dialog: $result');
      setState(() {
        _selectedHealthConditions = result;
        print('Updated health conditions in state: $_selectedHealthConditions');
      });
    }
  }

  Widget _buildAllergyChip(String allergy) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              allergy,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
            const SizedBox(width: 4.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAllergies.remove(allergy);
                });
              },
              child: Icon(
                IconlyLight.closeSquare,
                size: 16,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthConditionChip(Map<String, dynamic> condition) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              condition['condition'] ?? 'Unknown',
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
            const SizedBox(width: 4.0),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedHealthConditions.remove(condition);
                });
              },
              child: Icon(
                IconlyLight.closeSquare,
                size: 16,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building ProfileScreen');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(IconlyLight.arrowLeft2, color: Colors.black),
            onPressed: () {
              // Pop the current route to return to HomeScreen
              widget.navigatorKey.currentState!.pop();
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orangeAccent, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Profile',
                      style: GoogleFonts.lobster(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icon.png',
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        size: 40,
                        color: Colors.red,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: _toggleEditMode,
                child: Text(
                  _isEditing ? 'Discard' : 'Edit',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<UserProfileResponse>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          print('FutureBuilder state: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            print('Rendering UI with data: ${snapshot.data!.fullName}');
            print('UserProfile: ${snapshot.data!.toString()}');
            final userProfile = snapshot.data!;
            _fullNameController = TextEditingController(text: userProfile.fullName);
            _usernameController = TextEditingController(text: userProfile.username ?? 'N/A');
            _emailController = TextEditingController(text: userProfile.email);
            _allergyControllers = userProfile.allergies
                .map((allergy) => TextEditingController(text: allergy))
                .toList();
            _conditionControllers = userProfile.healthConditions
                .map((condition) => TextEditingController(text: condition.condition))
                .toList();

            print('Building ProfileAvatar');
            print('Building ProfileName');
            print('Building StatCard');
            print('Building SectionCard for Allergies');
            print('Building SectionCard for Health Conditions');
            print('Building SectionCard for Personal Information');

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatar(
                      userPicture: userProfile.userPicture,
                      upId: userProfile.upId,
                    ),
                    const SizedBox(height: 8),
                    ProfileName(
                      handle: userProfile.username ?? 'N/A',
                      name: userProfile.fullName,
                      isEditing: _isEditing,
                      fullNameController: _fullNameController,
                      usernameController: _usernameController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(title: 'Allergies', value: _selectedAllergies.length.toString()),
                        StatCard(title: 'Conditions', value: _selectedHealthConditions.length.toString()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: 'ALLERGIES',
                      icon: IconlyLight.dangerTriangle,
                      children: [
                        _isEditing
                            ? GestureDetector(
                          onTap: () => _showAllergiesDialog(context, _selectedAllergies),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _selectedAllergies.isEmpty
                                ? Text(
                              'No allergies selected',
                              style: TextStyle(color: Colors.grey[800], fontSize: 14),
                            )
                                : Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _selectedAllergies.map((allergy) => _buildAllergyChip(allergy)).toList(),
                            ),
                          ),
                        )
                            : Column(
                          children: _selectedAllergies
                              .asMap()
                              .entries
                              .map((entry) => ListItem(
                            title: entry.value,
                            dotColor: Colors.redAccent,
                            isEditing: false,
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: 'HEALTH CONDITIONS',
                      icon: IconlyLight.heart,
                      children: [
                        _isEditing
                            ? GestureDetector(
                          onTap: () => _showHealthConditionsDialog(context, _selectedHealthConditions),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: _selectedHealthConditions.isEmpty
                                ? Text(
                              'No conditions selected',
                              style: TextStyle(color: Colors.grey[800], fontSize: 14),
                            )
                                : Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _selectedHealthConditions.map((condition) => _buildHealthConditionChip(condition)).toList(),
                            ),
                          ),
                        )
                            : Column(
                          children: _selectedHealthConditions
                              .asMap()
                              .entries
                              .map((entry) => ListItem(
                            title: entry.value['condition'] ?? 'Unknown',
                            dotColor: Colors.grey,
                            isEditing: false,
                          ))
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      title: 'PERSONAL INFORMATION',
                      icon: IconlyLight.discovery,
                      children: [
                        _isEditing
                            ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _selectedAge,
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: List.generate(100, (index) => index + 1)
                                      .map((age) => DropdownMenuItem<int>(
                                    value: age,
                                    child: Text(age.toString()),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedAge = value;
                                    });
                                  },
                                  hint: const Text('Select Age'),
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListItem(
                          title: 'Age: ${userProfile.age?.toString() ?? 'N/A'}',
                          dotColor: Colors.grey,
                          isEditing: false,
                        ),
                        _isEditing
                            ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  decoration: const InputDecoration(
                                    labelText: 'Gender',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                  hint: const Text('Select Gender'),
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListItem(
                          title: 'Gender: ${userProfile.gender ?? 'N/A'}',
                          dotColor: Colors.grey,
                          isEditing: false,
                        ),
                        ListItem(
                          title: 'Email: ${userProfile.email}',
                          dotColor: Colors.grey,
                          isEditing: _isEditing,
                          controller: _emailController,
                          titlePrefix: 'Email: ',
                        ),
                      ],
                    ),
                    if (_isEditing) const SizedBox(height: 16),
                    if (_isEditing)
                      SaveButton(
                        onPressed: () => _saveProfile(userProfile),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}