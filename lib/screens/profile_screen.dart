import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../widgets/login_screen_widgets/profile_screen_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        ], // Actions
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image and Name
              const ProfileAvatar(),
              const SizedBox(height: 8),
              const ProfileName('@johndoe', 'John Doe', 'Member since 2023'),
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
                children: [
                  ListItem(title: 'Peanuts', dotColor: Colors.redAccent),
                  ListItem(title: 'Shellfish', dotColor: Colors.redAccent),
                  ListItem(title: 'Dairy', dotColor: Colors.redAccent),
                ],
              ),
              const SizedBox(height: 16),
              // Health Conditions Section
              SectionCard(
                title: 'HEALTH CONDITIONS',
                icon: IconlyLight.heart,
                children: [
                  ListItem(
                    title: 'Asthma',
                    dotColor: Colors.grey,
                    subtitle: 'Moderate',
                  ),
                  ListItem(
                    title: 'Diabetes Type 2',
                    dotColor: Colors.grey,
                    subtitle: 'Controlled',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Personal Contact Section
              SectionCard(
                title: 'PERSONAL CONTACT',
                icon: IconlyLight.call,
                children: [
                  ListItem(title: 'Phone: 123456789', dotColor: Colors.grey),
                  ListItem(
                    title: 'Email: JOHNDOE@gmail.com',
                    dotColor: Colors.grey,
                  ),
                  ListItem(title: 'Country: England', dotColor: Colors.grey),
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
      ),
    );
  }
}
