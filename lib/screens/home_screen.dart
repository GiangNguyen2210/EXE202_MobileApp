import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchBoxVisible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        // Increased height for larger text/icon
        child: AppBar(
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
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _scrollToTop,
                    child: Text(
                      'App Chảo',
                      style: GoogleFonts.lobster(
                        fontSize: 30, // Increased size for prominence
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/icon.png',
                    height: 40, // Adjusted to match the text size
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
        ),
      ),
      body: Column(
        children: [
          // Second AppBar for Search and Profile Icons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isSearchBoxVisible)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Find recipe...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _isSearchBoxVisible = false;
                          });
                        },
                      ),
                    ),
                  ),
                IconButton(
                  icon: Icon(
                    _isSearchBoxVisible
                        ? IconlyLight.closeSquare
                        : IconlyLight.search,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchBoxVisible = !_isSearchBoxVisible;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(IconlyLight.user2, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController, // Attach ScrollController
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filters (Horizontal Scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryChip('All Recipes', isSelected: true),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Breakfast'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Lunch'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Dinner'),
                          const SizedBox(width: 8),
                          _buildCategoryChip('Snacks'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Recipe Grid (2 per row)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final recipes = [
                          {
                            'title': 'Honey Glazed Salmon',
                            'time': '25 mins',
                            'rating': '★★★★☆',
                            'author': 'By John Miller',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                          {
                            'title': 'Creamy Garlic Pasta',
                            'time': '30 mins',
                            'rating': '★★★★★',
                            'author': 'By John Cook',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                          {
                            'title': 'Classic Caesar Salad',
                            'time': '15 mins',
                            'rating': '★★★★☆',
                            'author': 'By Emma White',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                          {
                            'title': 'Chocolate Lava Cake',
                            'time': '40 mins',
                            'rating': '★★★★★',
                            'author': 'By Michael Brown',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                          {
                            'title': 'Spicy Thai Curry',
                            'time': '45 mins',
                            'rating': '★★★★☆',
                            'author': 'By Li Chen',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                          {
                            'title': 'Avocado Toast',
                            'time': '10 mins',
                            'rating': '★★★★☆',
                            'author': 'By David Park',
                            'imageUrl': 'https://via.placeholder.com/150',
                          },
                        ];
                        final recipe = recipes[index];
                        return _buildRecipeCard(
                          title: recipe['title']!,
                          time: recipe['time']!,
                          rating: recipe['rating']!,
                          author: recipe['author']!,
                          imageUrl: recipe['imageUrl']!,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Extra padding to avoid overlap
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.discovery),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bookmark),
            label: 'Save',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.buy),
            label: 'Shopping',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.user2),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Chip(
      label: Text(label),
      backgroundColor: isSelected ? Colors.orange[100] : Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.orange : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildRecipeCard({
    required String title,
    required String time,
    required String rating,
    required String author,
    required String imageUrl,
  }) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.grey[300]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      IconlyLight.timeCircle,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      IconlyLight.star,
                      size: 14,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
