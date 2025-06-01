import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LoginBGPicture.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40), // Reduced height to push header up
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 60, // Slightly smaller logo
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'App Chảo',
                      style: TextStyle(
                        fontSize: 24, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        fontSize: 18, // Reduced font size
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 1),
                SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    padding: const EdgeInsets.all(20), // Reduced padding
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12), // Reduced padding
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Basic',
                                style: TextStyle(
                                  fontSize: 16, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '99 000 VND /month',
                                style: GoogleFonts.poppins(
                                  fontSize: 20, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildPlanFeature('5 recipe suggestions per day'),
                              _buildPlanFeature('Basic ingredient analysis'),
                              _buildPlanFeature(
                                  'AI chat support (slow, low priority)'),
                              _buildPlanFeature('Save 10 favorite recipes'),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14), // Adjusted padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Selected Basic Plan - 99,000 VND/month")),
                                    );
                                  },
                                  child: const Text(
                                    "Choose Basic",
                                    style: TextStyle(
                                      fontSize: 14, // Reduced font size
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12), // Reduced padding
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Premium',
                                style: TextStyle(
                                  fontSize: 16, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '199 000 VND /month',
                                style: GoogleFonts.poppins(
                                  fontSize: 20, // Reduced font size
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildPlanFeature('Unlimited recipe suggestions',
                                  isPremium: true),
                              _buildPlanFeature(
                                  'Advanced ingredient analysis (with nutrition)',
                                  isPremium: true),
                              _buildPlanFeature(
                                  'AI chat support (fast, high priority)',
                                  isPremium: true),
                              _buildPlanFeature('Unlimited recipe storage',
                                  isPremium: true),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14), // Adjusted padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Selected Premium Plan - 199,000 VND/month")),
                                    );
                                  },
                                  child: const Text(
                                    "Choose Premium",
                                    style: TextStyle(
                                      fontSize: 14, // Reduced font size
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'All plans include 14-day free trial',
                          style: TextStyle(
                            fontSize: 12, // Reduced font size
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          // TODO: Handle navigation
        },
      ),
    );
  }

  Widget _buildPlanFeature(String feature, {bool isPremium = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0), // Reduced padding
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: isPremium ? Colors.white : Colors.blue,
            size: 18, // Reduced icon size
          ),
          const SizedBox(width: 6),
          Text(
            feature,
            style: TextStyle(
              fontSize: 12, // Reduced font size
              color: isPremium ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}