import 'package:flutter/material.dart';

class HealthConditionScreen extends StatefulWidget {
  const HealthConditionScreen({super.key});

  @override
  State<HealthConditionScreen> createState() => _HealthConditionScreenState();
}

class _HealthConditionScreenState extends State<HealthConditionScreen> {
  final Map<String, bool> _conditions = {
    'Diabetes': false,
    'High Blood Pressure': false,
    'Heart Disease': false,
    'Asthma': false,
    'Arthritis': false,
    'Allergies': false,
    'Depression/Anxiety': false,
    'Sleep Disorders': false,
  };

  final Map<String, String> _subtitles = {
    'Diabetes': 'Type 1 or Type 2 diabetes',
    'High Blood Pressure': 'Hypertension',
    'Heart Disease': 'Cardiovascular conditions',
    'Asthma': 'Respiratory condition',
    'Arthritis': 'Joint inflammation',
    'Allergies': 'Food or environmental',
    'Depression/Anxiety': 'Mental health conditions',
    'Sleep Disorders': 'Sleep-related conditions',
  };

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
                  itemCount: _conditions.length,
                  itemBuilder: (context, index) {
                    final condition = _conditions.keys.elementAt(index);
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
                                  condition,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _subtitles[condition]!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _conditions[condition]!,
                            onChanged: (val) {
                              setState(() {
                                _conditions[condition] = val;
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
                      onPressed: () {},
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
                        final selected = _conditions.entries
                            .where((e) => e.value)
                            .map((e) => e.key)
                            .toList();
                        print("Selected: $selected");
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
