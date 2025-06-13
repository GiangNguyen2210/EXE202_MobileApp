import 'package:exe202_mobile_app/screens/profile_screen.dart';
import 'package:exe202_mobile_app/screens/recipe_detail_screen.dart'; // Thêm import
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/home_screen_widgets/category_chip_widget.dart';
import '../widgets/home_screen_widgets/recipe_card_widget.dart';
import '../api/recipe_api.dart';
import '../models/DTOs/recipe_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  String? _searchTerm;
  late int _totalPages = 1;
  List<RecipeItem> _allRecipes = [];
  final TextEditingController _searchController = TextEditingController();

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
    _searchController.dispose();
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

  Future<List<RecipeResponse>> _preloadRecipes(int currentPage) async {
    try {
      final api = RecipeApi();
      final response = await api.fetchRecipes(
        page: 1,
        pageSize: _recipesPerPage,
        mealName: _selectedCategory?.toLowerCase(),
        searchTerm: _searchTerm,
      );

      final totalPages = response.totalCount > 0
          ? (response.totalCount / _recipesPerPage).ceil()
          : 0;

      setState(() {
        _totalPages = totalPages;
      });

      if (response.totalCount == 0 || response.items.isEmpty) {
        setState(() {
          _allRecipes = [];
        });
        return [response];
      }

      final maxPage = _totalPages;
      int startPage = (currentPage - 2).clamp(1, maxPage);
      int endPage = (currentPage + 2).clamp(1, maxPage);

      List<Future<RecipeResponse>> futures = [];
      for (int page = startPage; page <= endPage; page++) {
        futures.add(
          api.fetchRecipes(
            page: page,
            pageSize: _recipesPerPage,
            mealName: _selectedCategory?.toLowerCase(),
            searchTerm: _searchTerm,
          ),
        );
      }

      final responses = await Future.wait(futures);
      final allItems = responses.expand((response) => response.items).toList();

      setState(() {
        _allRecipes = allItems;
      });

      return responses;
    } catch (e) {
      print('Error in _preloadRecipes: $e');
      setState(() {
        _allRecipes = [];
        _totalPages = 0;
      });
      rethrow;
    }
  }

  void _onCategorySelected(String category) {
    print('Category selected: $category');
    setState(() {
      _selectedCategory = category == 'All Recipes' ? null : category;
      _currentPage = 0;
      _allRecipes = [];
      _totalPages = 1;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    setState(() {
      _fetchRecipesFuture = _preloadRecipes(1);
    });
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchTerm = value.trim().isEmpty ? null : value.trim();
      _isSearchBoxVisible = false;
      _currentPage = 0;
      _allRecipes = [];
      _totalPages = 1;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }

    setState(() {
      _fetchRecipesFuture = _preloadRecipes(1);
    });

    _searchController.clear();
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
                            controller: _searchController,
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
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchTerm = null;
                                    _fetchRecipesFuture = _preloadRecipes(1);
                                  });
                                },
                              ),
                            ),
                            onSubmitted: _onSearchSubmitted,
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
                          if (!_isSearchBoxVisible) {
                            _searchController.clear();
                            _searchTerm = null;
                            _fetchRecipesFuture = _preloadRecipes(1);
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.profile, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
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
                    alignment: WrapAlignment.start,
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
                              _searchTerm != null
                                  ? 'No recipes found for "$_searchTerm"'
                                  : _selectedCategory == null
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
                              _searchTerm != null
                                  ? 'Try a different search term or category!'
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

                    return PageView.builder(
                      controller: _pageController,
                      itemCount: _totalPages,
                      itemBuilder: (context, pageIndex) {
                        final startIndex = pageIndex * _recipesPerPage;
                        final endIndex =
                        (startIndex + _recipesPerPage) > recipes.length
                            ? recipes.length
                            : (startIndex + _recipesPerPage);

                        if (startIndex >= recipes.length) {
                          return const Center(
                            child: Text('No more recipes on this page'),
                          );
                        }

                        final pageRecipes = recipes.sublist(
                          startIndex,
                          endIndex,
                        );

                        if (_scrollControllers.length <= pageIndex) {
                          _scrollControllers.add(ScrollController());
                        }

                        return SingleChildScrollView(
                          controller: _scrollControllers[pageIndex],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
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
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const RecipeDetailScreen(),
                                            settings: RouteSettings(
                                              arguments: {'recipeId': recipe.recipeId},
                                            ),
                                          ),
                                        );
                                      },
                                      child: RecipeCard(
                                        title: recipe.recipeName,
                                        time: '${recipe.timeEstimation} mins',
                                        difficultyEstimation:
                                        recipe.difficultyEstimation,
                                        mealName: recipe.mealName,
                                        imageUrl: recipe.imageUrl,
                                      ),
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