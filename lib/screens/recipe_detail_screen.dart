import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../api/recipe_detail_api.dart';
import '../models/DTOs/recipe_detail_modal.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _isNavBarVisible = true;
  late ScrollController _scrollController;
  late Future<RecipeDetail> _fetchRecipeFuture;
  int _servings = 1;
  YoutubePlayerController? _youtubeController;
  bool _videoLoadFailed = false;
  int? _recipeId;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fetchRecipeFuture = Future.value(
      RecipeDetail(
        recipeId: 0,
        recipeName: 'Loading...',
        meals: '',
        difficultyEstimation: 0,
        timeEstimation: 0,
        nation: '',
        cuisineId: 0,
        instructionVideoLink: '',
        ingredients: [],
        steps: [],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final int recipeId = args?['recipeId'] ?? 33;
    if (_recipeId != recipeId) {
      _recipeId = recipeId;
      _youtubeController?.dispose();
      _youtubeController = null;
      _videoId = null;
      _videoLoadFailed = false;
      final api = RecipeDetailApi();
      _fetchRecipeFuture = api.fetchRecipeDetail(recipeId).then((recipe) {
        _processVideoId(recipe.instructionVideoLink);
        // Khởi tạo _servings bằng defaultServing nếu có
        setState(() {
          _servings = recipe.defaultServing ?? 1;
        });
        return recipe;
      });
    }
  }

  void _processVideoId(String instructionVideoLink) {
    final videoId = YoutubePlayer.convertUrlToId(instructionVideoLink);
    if (videoId != null) {
      _youtubeController =
          YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          )..addListener(() {
            if (_youtubeController!.value.hasError && !_videoLoadFailed) {
              setState(() {
                _videoLoadFailed = true;
                _youtubeController?.dispose();
                _youtubeController = null;
                _videoId = null;
              });
            }
          });
      _videoId = videoId;
    } else {
      _videoLoadFailed = true;
      _videoId = null;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _youtubeController?.dispose();
    super.dispose();
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollUpdateNotification) {
      if (scrollInfo.scrollDelta != null) {
        if (scrollInfo.scrollDelta! > 0 && _isNavBarVisible) {
          setState(() => _isNavBarVisible = false);
        } else if (scrollInfo.scrollDelta! < 0 && !_isNavBarVisible) {
          setState(() => _isNavBarVisible = true);
        }
      }
    }
  }

  String _getDifficultyStars(int difficulty) {
    const filledStar = '★';
    const emptyStar = '☆';
    return 'Difficulty: ${filledStar * difficulty}${emptyStar * (5 - difficulty)}';
  }

  String _getNationWithFlag(String nation) {
    final flagMap = {
      'Viet Nam': '🇻🇳',
      'Italy': '🇮🇹',
      'France': '🇫🇷',
      'USA': '🇺🇸',
    };
    final flag = flagMap[nation] ?? '';
    return '$flag $nation';
  }

  void _updateServings(int change) {
    setState(() {
      _servings = (_servings + change).clamp(1, 10);
    });
  }

  List<Map<String, dynamic>> _parseRecipeSteps(String? recipeSteps) {
    if (recipeSteps == null || recipeSteps.isEmpty) {
      return [];
    }
    final steps = recipeSteps
        .split(RegExp(r'(?=\d+\.)'))
        .where((s) => s.isNotEmpty)
        .toList()
        .asMap()
        .entries
        .map((entry) {
          final step = entry.value.trim();
          final stepNumberMatch = RegExp(r'^(\d+)\.').firstMatch(step);
          final stepNumber = stepNumberMatch != null
              ? int.parse(stepNumberMatch.group(1)!)
              : entry.key + 1;
          final instruction = step.replaceFirst(RegExp(r'^\d+\.\s*'), '');
          return {'stepNumber': stepNumber, 'instruction': instruction};
        })
        .toList();
    return steps;
  }

  String _calculateIngredientAmount(
    String amount,
    int servings,
    int defaultServing,
  ) {
    try {
      final baseAmount = double.parse(amount); // Chuyển amount thành số
      final ratio =
          servings / (defaultServing == 0 ? 1 : defaultServing); // Tính tỉ lệ
      final newAmount = baseAmount * ratio;
      // Làm tròn dựa trên defaultUnit
      if (newAmount % 1 == 0) {
        return newAmount.toInt().toString(); // Số nguyên
      } else {
        return newAmount.toStringAsFixed(1); // 1 chữ số thập phân
      }
    } catch (e) {
      return amount; // Trả về nguyên gốc nếu lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<RecipeDetail>(
        future: _fetchRecipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load recipe detail'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No recipe data available'));
          }

          final recipe = snapshot.data!;
          final String title = recipe.recipeName;
          final String time = "${recipe.timeEstimation} mins";
          final String difficultyStars = _getDifficultyStars(
            recipe.difficultyEstimation.clamp(1, 5),
          );
          final String nationWithFlag = _getNationWithFlag(recipe.nation);
          final steps = recipe.steps.isNotEmpty
              ? recipe.steps
              : _parseRecipeSteps(recipe.recipeSteps)
                    .map(
                      (s) => RecipeStep(
                        stepNumber: s['stepNumber'] as int,
                        instruction: s['instruction'] as String,
                      ),
                    )
                    .toList();
          final defaultServing = recipe.defaultServing ?? 1;

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              _onScrollNotification(scrollInfo);
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_youtubeController != null && !_videoLoadFailed)
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.red,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.redAccent,
                        ),
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          RemainingDuration(),
                          PlaybackSpeedButton(),
                        ],
                        onReady: () {},
                        onEnded: (metaData) {
                          _youtubeController?.seekTo(Duration.zero);
                        },
                      ),
                    )
                  else
                    Stack(
                      children: [
                        Image.network(
                          recipe.instructionVideoLink,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                            );
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
                          difficultyStars,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                              const Icon(
                                Icons.flag,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                nationWithFlag,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Icon(
                                Icons.restaurant,
                                size: 18,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                recipe.meals,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
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
                                    onPressed: () => _updateServings(-1),
                                  ),
                                  Text(
                                    '$_servings serving${_servings == 1 ? '' : 's'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _updateServings(1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: recipe.ingredients.map((ingredient) {
                            final adjustedAmount = _calculateIngredientAmount(
                              ingredient.amount,
                              _servings,
                              defaultServing,
                            );
                            return _buildIngredientItem(
                              '$adjustedAmount ${ingredient.defaultUnit} ${ingredient.ingredient}',
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
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
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${steps[index].stepNumber}.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      steps[index].instruction,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
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
                            children: [
                              _buildSuggestedRecipeCard(
                                title: 'Creamy Pasta Alfredo',
                                time: '25 mins',
                                imageUrl: 'https://via.placeholder.com/150',
                              ),
                              const SizedBox(width: 16),
                              _buildSuggestedRecipeCard(
                                title: 'Penne Arrabbiata',
                                time: '20 mins',
                                imageUrl: 'https://via.placeholder.com/150',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _isNavBarVisible
          ? SizedBox(
              height: 82.0,
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
          Text(ingredient, style: const TextStyle(fontSize: 10)),
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
