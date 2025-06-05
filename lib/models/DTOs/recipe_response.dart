class RecipeResponse {
  final List<RecipeItem> items;
  final int page;
  final int pageSize;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  RecipeResponse({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    return RecipeResponse(
      items: (json['items'] as List)
          .map((item) => RecipeItem.fromJson(item))
          .toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      totalCount: json['totalCount'],
      hasNextPage: json['hasNextPage'],
      hasPreviousPage: json['hasPreviousPage'],
    );
  }
}

class RecipeItem {
  final int recipeId;
  final String recipeName;
  final int timeEstimation;
  final int difficultyEstimation;
  final String mealName;
  final String imageUrl;

  RecipeItem({
    required this.recipeId,
    required this.recipeName,
    required this.timeEstimation,
    required this.difficultyEstimation,
    required this.mealName,
    required this.imageUrl,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    return RecipeItem(
      recipeId: json['recipeId'],
      recipeName: json['recipeName'],
      timeEstimation: json['timeEstimation'],
      difficultyEstimation: json['difficultyEstimation'],
      mealName: json['mealName'],
      imageUrl: json['imageUrl'],
    );
  }
}