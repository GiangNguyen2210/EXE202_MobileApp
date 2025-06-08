import 'package:exe202_mobile_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_screen_widgets/category_chip_widget.dart';
import '../widgets/home_screen_widgets/recipe_card_widget.dart';
import '../api/recipe_api.dart';
import '../models/DTOs/recipe_response.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const HomeScreen({super.key, required this.navigatorKey});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearchBoxVisible = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _recipesPerPage = 10;
  final List<ScrollController> _scrollControllers = [];
  late Future<List<RecipeResponse>> _fetchRecipesFuture;
  String? _selectedCategory;
  late int _totalPages = 1;
  List<RecipeItem> _allRecipes = [];
  final TextEditingController _searchController = TextEditingController(); // New: Controller for search input
  String _searchQuery = ''; // New: Store the current search query

  @override
  void initState() {
    super.initState();
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
    _searchController.dispose(); // New: Dispose of the search controller
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
    try {
      final api = RecipeApi();
      final response = await api.fetchRecipes(
          page: 1,
          pageSize: _recipesPerPage,
          mealName: _selectedCategory?.toLowerCase(),
          searchTerm: _searchQuery.isNotEmpty ? _searchQuery : null // New: Pass searchTerm
      );

      // Always update total pages first
      final totalPages = response.totalCount > 0
          ? (response.totalCount / _recipesPerPage).ceil()
          : 0;

      setState(() {
        _totalPages = totalPages;
      });

      // If no recipes found, return empty list and update state
      if (response.totalCount == 0 || response.items.isEmpty) {
        setState(() {
          _allRecipes = [];
        });
        return [response];
      }

      // Only proceed with multi-page loading if we have recipes
      final maxPage = _totalPages;
      int startPage = (currentPage - 2).clamp(1, maxPage);
      int endPage = (currentPage + 2).clamp(1, maxPage);

      List<Future<RecipeResponse>> futures = [];
      for (int page = startPage; page <= endPage; page++) {
        futures.add(api.fetchRecipes(
            page: page,
            pageSize: _recipesPerPage,
            mealName: _selectedCategory?.toLowerCase(),
            searchTerm: _searchQuery.isNotEmpty ? _searchQuery : null // New: Pass searchTerm
        ));
      }

      final responses = await Future.wait(futures);
      final allItems = responses.expand((response) => response.items).toList();

      setState(() {
        _allRecipes = allItems;
      });

      return responses;
    } catch (e) {
      print('Error in _preloadRecipes: $e'); // Add debug logging
      // Handle API errors gracefully
      setState(() {
        _allRecipes = [];
        _totalPages = 0;
      });
      rethrow; // Re-throw to let FutureBuilder handle the error
    }
  }

  void _onCategorySelected(String category) {
    print('Category selected: $category'); // Debug logging

    setState(() {
      _selectedCategory = category == 'All Recipes' ? null : category;
      _currentPage = 0;
      _allRecipes = []; // Clear existing recipes immediately
      _totalPages = 1; // Reset to prevent UI issues
      _searchQuery = ''; // New: Clear search query when category changes
      _searchController.clear(); // New: Clear search input
    });

    // Reset page controller first
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    // Then fetch new data
    setState(() {
      _fetchRecipesFuture = _preloadRecipes(1);
    });
  }

  // New: Handle search submission
  void _onSearchSubmitted(String query) {
    setState(() {
      _searchQuery = query.trim();
      _currentPage = 0;
      _allRecipes = [];
      _totalPages = 1;
      _isSearchBoxVisible = false; // Hide search bar after submission
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    setState(() {
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
                            controller: _searchController, // New: Use controller
                            decoration: InputDecoration(
                              hintText: 'Find recipe...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                            ),
                            onSubmitted: _onSearchSubmitted, // New: Handle submission
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
                          if (!_isSearchBoxVisible) {
                            _searchController.clear();
                            _searchQuery = '';
                            _fetchRecipesFuture = _preloadRecipes(1); // Reset recipes
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.profile, color: Colors.grey),
                      onPressed: () {
                        // Navigate to ProfileScreen using the root navigator
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              navigatorKey: widget.navigatorKey,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 6.0,
                    runSpacing: 8.0,
                    alignment: WrapAlignment.start, // Ensure chips start from the left
                    children: [
                      CategoryChip(
                        label: 'All Recipes',
                        isSelected: _selectedCategory == null,
                        onTap: () => _onCategorySelected('All Recipes'),
                      ),
                      CategoryChip(
                        label: 'Breakfast',
                        isSelected: _selectedCategory == 'Breakfast',
                        onTap: () => _onCategorySelected('Breakfast'),
                      ),
                      CategoryChip(
                        label: 'Lunch',
                        isSelected: _selectedCategory == 'Lunch',
                        onTap: () => _onCategorySelected('Lunch'),
                      ),
                      CategoryChip(
                        label: 'Dinner',
                        isSelected: _selectedCategory == 'Dinner',
                        onTap: () => _onCategorySelected('Dinner'),
                      ),
                      CategoryChip(
                        label: 'Snacks',
                        isSelected: _selectedCategory == 'Snacks',
                        onTap: () => _onCategorySelected('Snacks'),
                      ),
                    ],
                  ),
                ),
              ),
              // Update your FutureBuilder section in HomeScreen's build method
              Expanded(
                child: FutureBuilder<List<RecipeResponse>>(
                  future: _fetchRecipesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Oops! Something went wrong',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Please try again later',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || _allRecipes.isEmpty) {
                      // Handle empty state with better messaging
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedCategory == null
                                  ? 'No recipes available yet'
                                  : 'No ${_selectedCategory!.toLowerCase()} recipes yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedCategory == null
                                  ? 'Check back later for delicious recipes!'
                                  : 'Try exploring other categories or check back later!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final recipes = _allRecipes;

                    // This check is no longer needed since we always have at least 1 page

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: _totalPages,
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * _recipesPerPage;
                        final endIndex = (startIndex + _recipesPerPage) > recipes.length
                            ? recipes.length
                            : (startIndex + _recipesPerPage);

                        // Handle case where we don't have recipes for this page
                        if (startIndex >= recipes.length) {
                          return const Center(
                            child: Text('No more recipes on this page'),
                          );
                        }

                        final pageRecipes = recipes.sublist(startIndex, endIndex);

                        if (_scrollControllers.length <= pageIndex) {
                          _scrollControllers.add(ScrollController());
                        }

                        return SingleChildScrollView(
                          controller: _scrollControllers[pageIndex],
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
            bottom: 0,
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
    );
  }
}

// extension on OverlayState {
//   get navigatorKey => ProfileScreen(navigatorKey: GlobalKey());
// }