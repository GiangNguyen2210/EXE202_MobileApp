import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../api/profile_api.dart';
import '../models/DTOs/user_profile_response.dart';
import '../widgets/profile_screen_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfileResponse> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    // Replace with the actual UPId (e.g., from login or route parameters)
    _userProfileFuture = ProfileApi().fetchUserProfile(1); // Mock UPId for now
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(IconlyLight.arrowLeft2, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<UserProfileResponse>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userProfile = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image and Name
                    ProfileAvatar(
                      userPicture: userProfile.userPicture,
                      upId: userProfile.upId,
                    ),
                    const SizedBox(height: 8),
                    ProfileName(
                      userProfile.username ?? '@johndoe',
                      userProfile.fullName ?? 'John Doe',
                      'Member since 2023',
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatCard(title: 'Allergies', value: '12'),
                        StatCard(title: 'Conditions', value: '3'),
                        StatCard(title: 'Medications', value: '4'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Allergies Section
                    SectionCard(
                      title: 'ALLERGIES',
                      icon: IconlyLight.dangerTriangle,
                      children: userProfile.allergies
                          .map((allergy) => ListItem(
                        title: allergy,
                        dotColor: Colors.redAccent,
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    // Health Conditions Section
                    SectionCard(
                      title: 'HEALTH CONDITIONS',
                      icon: IconlyLight.heart,
                      children: userProfile.healthConditions
                          .map((condition) => ListItem(
                        title: condition,
                        dotColor: Colors.grey,
                        subtitle: condition == 'Asthma'
                            ? 'Moderate'
                            : 'Controlled',
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    // Personal Information Section
                    SectionCard(
                      title: 'PERSONAL INFORMATION',
                      icon: IconlyLight.discovery,
                      children: [
                        ListItem(
                          title: 'Age: ${userProfile.age?.toString() ?? '28'}',
                          dotColor: Colors.grey,
                        ),
                        ListItem(
                          title: 'Gender: ${userProfile.gender ?? 'Male'}',
                          dotColor: Colors.grey,
                        ),
                        ListItem(
                          title: 'Email: ${userProfile.email ?? 'JOHNDOE@gmail.com'}',
                          dotColor: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Medical ID Button
                    MedicalIdCard(),
                    const SizedBox(height: 16),
                    // Update Health Info Button
                    UpdateHealthButton(),
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