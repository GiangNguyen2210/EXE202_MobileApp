import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearchBoxVisible = false;
  final PageController _pageController = PageController();
  bool _isNavBarVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _navBarAnimation;
  int _currentPage = 0;
  final int _recipesPerPage = 14; // 14 recipes per page (7 rows of 2)
  final List<ScrollController> _scrollControllers =
  []; // One ScrollController per page

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _navBarAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Initialize ScrollControllers for each page
    final int totalPages = (42 / _recipesPerPage).ceil(); // Based on 42 recipes
    for (int i = 0; i < totalPages; i++) {
      _scrollControllers.add(ScrollController());
    }

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
      _scrollToTop(); // Auto-scroll to top on page change
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollControllers.isNotEmpty &&
        _currentPage < _scrollControllers.length) {
      _scrollControllers[_currentPage].animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simulated recipe data (42 recipes for 3 pages)
    final List<Map<String, String>> allRecipes = List.generate(42, (index) {
      return {
        'title': 'Recipe ${index + 1}',
        'time': '${15 + (index % 30)} mins',
        'rating': '★★★★☆',
        'author': 'By Chef ${index % 5 + 1}',
        'imageUrl': 'https://via.placeholder.com/150',
      };
    });

    final int totalPages = (allRecipes.length / _recipesPerPage).ceil();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
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
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14.0,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
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
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    final startIndex = pageIndex * _recipesPerPage;
                    final endIndex =
                    (startIndex + _recipesPerPage) > allRecipes.length
                        ? allRecipes.length
                        : (startIndex + _recipesPerPage);
                    final pageRecipes = allRecipes.sublist(
                      startIndex,
                      endIndex,
                    );

                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification notification) {
                        if (notification is ScrollUpdateNotification) {
                          if (notification.scrollDelta! > 0 &&
                              _isNavBarVisible) {
                            setState(() {
                              _isNavBarVisible = false;
                            });
                            _animationController.forward();
                          } else if (notification.scrollDelta! < 0 &&
                              !_isNavBarVisible) {
                            setState(() {
                              _isNavBarVisible = true;
                            });
                            _animationController.reverse();
                          }
                        }
                        return true;
                      },
                      child: SingleChildScrollView(
                        controller: _scrollControllers[pageIndex],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
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
                                itemCount: pageRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = pageRecipes[index];
                                  return _buildRecipeCard(
                                    title: recipe['title']!,
                                    time: recipe['time']!,
                                    rating: recipe['rating']!,
                                    author: recipe['author']!,
                                    imageUrl: recipe['imageUrl']!,
                                  );
                                },
                              ),
                              const SizedBox(height: 48),
                              // Reserve space for page counter
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          // Page counter positioned dynamically
          Positioned(
            left: 0,
            right: 0,
            bottom: _isNavBarVisible ? -5.0 : -10.0,
            // Move up when navbar is visible, down when hidden
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.grey),
                    onPressed: _currentPage > 0
                        ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                        : null,
                  ),
                  Text(
                    'Page ${_currentPage + 1} of $totalPages',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.grey),
                    onPressed: _currentPage < totalPages - 1
                        ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isNavBarVisible
          ? SlideTransition(
        position: _navBarAnimation,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Home',),
            BottomNavigationBarItem(icon: Icon(IconlyLight.discovery), label: 'Explore',),
            BottomNavigationBarItem(icon: Icon(IconlyLight.bookmark), label: 'Save',),
            BottomNavigationBarItem(icon: Icon(IconlyLight.buy), label: 'Shopping',),
            BottomNavigationBarItem(icon: Icon(IconlyLight.user2), label: 'Profile',),
          ],
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          currentIndex: 0,
          onTap: (index) {},
        ),
      )
          : null,
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
