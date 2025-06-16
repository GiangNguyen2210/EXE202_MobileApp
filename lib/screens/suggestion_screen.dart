import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuggestionScreen extends StatelessWidget {
  SuggestionScreen({super.key});

  final List<String> _healthProfile = ['Low Sodium', 'Diabetic-Friendly', 'Heart Healthy'];
  final List<Map<String, dynamic>> _aiPicks = [
    {
      'recipeId': '1',
      'recipeName': 'Protein-Rich Quinoa Bowl',
      'calories': '320 cal',
      'matchPercentage': '95%',
      'healthLabels': ['High Protein', 'Low Glycemic'],
      'imageUrl': 'https://example.com/quinoa_bowl.jpg',
    },
    {
      'recipeId': '2',
      'recipeName': 'Mediterranean Salad',
      'calories': '450 cal',
      'matchPercentage': '85%',
      'healthLabels': ['Heart-Healthy'],
      'imageUrl': 'https://example.com/mediterranean_salad.jpg',
    },
  ];
  final List<String> _filters = ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks'];
  final List<String> _whyRecipes = [
    'Low in sodium to support heart health',
    'Rich in fiber for blood sugar control',
    'High in omega-3 fatty acids',
    'Balanced macro-nutrients',
  ];

  // Fixed widget to prevent overflow
  Widget _buildSuggestionRecipeCard(Map<String, dynamic> recipe, BuildContext context) {
    return Container(
      width: 160,
      height: 200,
      margin: const EdgeInsets.only(right: 12.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with fixed height
            SizedBox(
              height: 100, // Reduced from 120 to give more space for content
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  recipe['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            // Content section with proper constraints
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Recipe name
                    Text(
                      recipe['recipeName'],
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Calories and match percentage
                    Text(
                      '${recipe['calories']} | ${recipe['matchPercentage']} Match',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Health labels with proper constraints
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: (recipe['healthLabels'] as List).map((label) =>
                              Container(
                                margin: const EdgeInsets.only(right: 4.0),
                                child: Chip(
                                  label: Text(
                                      label,
                                      style: const TextStyle(fontSize: 8)
                                  ),
                                  backgroundColor: Colors.blue.withOpacity(0.2),
                                  labelStyle: const TextStyle(color: Colors.blue),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                          ).toList(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Recipe Suggestions',
          style: GoogleFonts.lobster(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orangeAccent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Personalized for your health',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Your Health Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _healthProfile.map((profile) {
                Color color = profile == 'Low Sodium' ? Colors.blue
                    : profile == 'Diabetic-Friendly' ? Colors.green
                    : Colors.redAccent;
                return Chip(
                  label: Text(profile),
                  backgroundColor: color.withOpacity(0.2),
                  labelStyle: TextStyle(color: color),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              "Today's AI Picks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _aiPicks.length,
                itemBuilder: (context, index) {
                  final recipe = _aiPicks[index];
                  return _buildSuggestionRecipeCard(recipe, context);
                },
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Why these recipes?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Based on your health profile, we\'ve selected recipes that are:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  ..._whyRecipes.map((reason) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(child: Text(reason)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}