import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_screen_widgets/category_chip_widget.dart';
import '../widgets/home_screen_widgets/recipe_card_widget.dart';
import '../widgets/app_bottom_navigation.dart';
import '../api/recipe_api.dart';
import '../models/DTOs/recipe_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isSearchBoxVisible = false;
  final PageController _pageController = PageController();
  bool _isNavBarVisible = true;
  late AnimationController _animationController;
  late Animation<Offset> _navBarAnimation;
  int _currentPage = 0;
  final int _recipesPerPage = 10;
  final List<ScrollController> _scrollControllers = [];
  late Future<List<RecipeResponse>> _fetchRecipesFuture;
  String? _selectedCategory;
  late int _totalPages = 1;
  List<RecipeItem> _allRecipes = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _navBarAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fetchRecipesFuture = _preloadRecipes(1);
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
        _scrollToTop();
        _preloadRecipes(_currentPage + 1);
      }
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
    if (_scrollControllers.isNotEmpty && _currentPage < _scrollControllers.length) {
      _scrollControllers[_currentPage].animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<List<RecipeResponse>> _preloadRecipes(int currentPage) async {
    final api = RecipeApi();
    final response = await api.fetchRecipes(page: 1, pageSize: _recipesPerPage, mealName: _selectedCategory?.toLowerCase());
    setState(() {
      _totalPages = (response.totalCount / _recipesPerPage).ceil();
    });

    final maxPage = _totalPages;

    int startPage = (currentPage - 2).clamp(1, maxPage);
    int endPage = (currentPage + 2).clamp(1, maxPage);

    List<Future<RecipeResponse>> futures = [];
    for (int page = startPage; page <= endPage; page++) {
      futures.add(api.fetchRecipes(page: page, pageSize: _recipesPerPage, mealName: _selectedCategory?.toLowerCase()));
    }

    final responses = await Future.wait(futures);
    setState(() {
      _allRecipes = responses.expand((response) => response.items).toList();
    });
    return responses;
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category == 'All Recipes' ? null : category;
      _currentPage = 0; // Reset current page to 0
      _pageController.jumpToPage(0); // Jump to page 1
      _fetchRecipesFuture = _preloadRecipes(1);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
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
                        _isSearchBoxVisible ? IconlyLight.closeSquare : IconlyLight.search,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearchBoxVisible = !_isSearchBoxVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.profile, color: Colors.grey),
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
                      CategoryChip(
                        label: 'All Recipes',
                        isSelected: _selectedCategory == null,
                        onTap: () => _onCategorySelected('All Recipes'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        label: 'Breakfast',
                        isSelected: _selectedCategory == 'Breakfast',
                        onTap: () => _onCategorySelected('Breakfast'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        label: 'Lunch',
                        isSelected: _selectedCategory == 'Lunch',
                        onTap: () => _onCategorySelected('Lunch'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        label: 'Dinner',
                        isSelected: _selectedCategory == 'Dinner',
                        onTap: () => _onCategorySelected('Dinner'),
                      ),
                      const SizedBox(width: 8),
                      CategoryChip(
                        label: 'Snacks',
                        isSelected: _selectedCategory == 'Snacks',
                        onTap: () => _onCategorySelected('Snacks'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<RecipeResponse>>(
                  future: _fetchRecipesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No recipes available'));
                    }

                    final recipes = _allRecipes;
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: _totalPages,
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * _recipesPerPage;
                        final endIndex = (startIndex + _recipesPerPage) > recipes.length
                            ? recipes.length
                            : (startIndex + _recipesPerPage);
                        final pageRecipes = recipes.sublist(startIndex, endIndex);

                        return NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            if (notification is ScrollUpdateNotification) {
                              if (notification.scrollDelta! > 0 && _isNavBarVisible) {
                                setState(() {
                                  _isNavBarVisible = false;
                                });
                                _animationController.forward();
                              } else if (notification.scrollDelta! < 0 && !_isNavBarVisible) {
                                setState(() {
                                  _isNavBarVisible = true;
                                });
                                _animationController.reverse();
                              }
                            }
                            return true;
                          },
                          child: SingleChildScrollView(
                            controller: _scrollControllers.length > pageIndex
                                ? _scrollControllers[pageIndex]
                                : ScrollController(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.65,
                                    ),
                                    itemCount: pageRecipes.length,
                                    itemBuilder: (context, index) {
                                      final recipe = pageRecipes[index];
                                      return RecipeCard(
                                        title: recipe.recipeName,
                                        time: '${recipe.timeEstimation} mins',
                                        difficultyEstimation: recipe.difficultyEstimation,
                                        mealName: recipe.mealName,
                                        imageUrl: recipe.imageUrl,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 48),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: _isNavBarVisible ? -10.0 : -10.0,
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
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.grey),
                    onPressed: _currentPage < _totalPages - 1
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
      bottomNavigationBar: AppBottomNavigation(
        items: const [
          BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(IconlyLight.discovery), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(IconlyLight.bookmark), label: 'Save'),
          BottomNavigationBarItem(icon: Icon(IconlyLight.buy), label: 'Shopping'),
          BottomNavigationBarItem(icon: Icon(IconlyLight.user2), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {},
        isVisible: _isNavBarVisible,
        animation: _navBarAnimation,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}