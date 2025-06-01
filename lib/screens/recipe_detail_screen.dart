import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isNavBarVisible = true; // Track visibility of the navigation bar
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollUpdateNotification) {
      // Check scroll direction
      if (scrollInfo.scrollDelta != null) {
        if (scrollInfo.scrollDelta! > 0) {
          // Scrolling down
          if (_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = false;
            });
          }
        } else if (scrollInfo.scrollDelta! < 0) {
          // Scrolling up
          if (!_isNavBarVisible) {
            setState(() {
              _isNavBarVisible = true;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    // Fallback values in case arguments are missing
    final String title = args?['title'] ?? 'Unknown Recipe';
    final String author = args?['author'] ?? 'Unknown Chef';
    final String time = args?['time'] ?? '0 mins';
    final String rating = args?['rating'] ?? '★★★★☆';
    final String imageUrl =
        args?['imageUrl'] ?? 'https://via.placeholder.com/150';
    // Extract rating number (assuming rating is in format "★★★★☆")
    final double ratingNumber =
        double.tryParse(
          rating.replaceAll('★', '').replaceAll('☆', '').trim(),
        ) ??
        4.8;

    // Mock data for cooking steps
    final List<String> cookingSteps = [
      'Boil the pasta in salted water according to package instructions until al dente.',
      'In a large pan, sauté minced garlic in butter until fragrant.',
      'Add the guanciale or pancetta and cook until crispy.',
      'Whisk the eggs with grated Pecorino Romano and Parmesan, then season with black pepper.',
      'Drain the pasta, reserving some cooking water, and add it to the pan with the guanciale.',
      'Remove the pan from heat, add the egg mixture, and toss quickly, adding reserved water as needed to create a creamy sauce.',
      'Serve immediately with extra cheese and black pepper on top.',
    ];

    // Mock data for suggested recipes
    final List<Map<String, String>> suggestedRecipes = [
      {
        'title': 'Creamy Pasta Alfredo',
        'time': '25 mins',
        'imageUrl': 'https://via.placeholder.com/150',
      },
      {
        'title': 'Penne Arrabbiata',
        'time': '20 mins',
        'imageUrl': 'https://via.placeholder.com/150',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Recipe Detail',
          style: GoogleFonts.lobster(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.bookmark, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          _onScrollNotification(scrollInfo);
          return false; // Return false to allow the notification to continue propagating
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with play button overlay
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(height: 200, color: Colors.grey[300]);
                    },
                  ),
                  Positioned.fill(
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 50,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 10,
                    right: 10,
                    child: Text(
                      '12:45',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
              // Recipe Title and Author
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      author,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating Section (separated)
                    Row(
                      children: [
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratingNumber.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Recipe Stats (time, nation, meal type)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const Icon(
                            IconlyLight.timeCircle,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.flag, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text(
                            'Italian',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.restaurant,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Dinner',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.speed, size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text(
                            'Medium',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ingredients Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                              const Text(
                                '4 servings',
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        _buildIngredientItem('400g spaghetti'),
                        _buildIngredientItem('200g guanciale or pancetta'),
                        _buildIngredientItem('4 large eggs'),
                        _buildIngredientItem('100g Pecorino Romano'),
                        _buildIngredientItem('100g Parmigiano Reggiano'),
                        _buildIngredientItem('Black pepper to taste'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Cooking Steps Section
                    const Text(
                      'Cooking Steps',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cookingSteps.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cookingSteps[index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Suggested Recipes Section
                    const Text(
                      'More Recipes You’ll Love',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: suggestedRecipes.map((recipe) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: _buildSuggestedRecipeCard(
                              title: recipe['title']!,
                              time: recipe['time']!,
                              imageUrl: recipe['imageUrl']!,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isNavBarVisible
          ? SizedBox(
              height: 60.0,
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.bookmark),
                    label: 'Saved',
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
                onTap: (index) {
                  if (index == 0) {
                    Navigator.pop(context);
                  }
                },
              ),
            )
          : null,
    );
  }

  Widget _buildIngredientItem(String ingredient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Text(ingredient, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildSuggestedRecipeCard({
    required String title,
    required String time,
    required String imageUrl,
  }) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(height: 100, color: Colors.grey[300]);
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
