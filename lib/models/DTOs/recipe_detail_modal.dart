class RecipeDetail {
  final int recipeId;
  final String recipeName;
  final String meals;
  final int difficultyEstimation;
  final int timeEstimation;
  final String nation;
  final int cuisineId;
  final String instructionVideoLink;
  final List<Ingredient> ingredients;
  final List<Step> steps;

  RecipeDetail({
    required this.recipeId,
    required this.recipeName,
    required this.meals,
    required this.difficultyEstimation,
    required this.timeEstimation,
    required this.nation,
    required this.cuisineId,
    required this.instructionVideoLink,
    required this.ingredients,
    required this.steps,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      recipeId: json['recipeId'],
      recipeName: json['recipeName'],
      meals: json['meals'],
      difficultyEstimation: json['difficultyEstimation'],
      timeEstimation: json['timeEstimation'],
      nation: json['nation'],
      cuisineId: json['cuisineId'],
      instructionVideoLink: json['instructionVideoLink'],
      ingredients: (json['ingredients'] as List)
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      steps: (json['steps'] as List).map((s) => Step.fromJson(s)).toList(),
    );
  }
}

class Ingredient {
  final String ingredient;
  final String amount;
  final String defaultUnit;

  Ingredient({
    required this.ingredient,
    required this.amount,
    required this.defaultUnit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      ingredient: json['ingredient'],
      amount: json['amount'],
      defaultUnit: json['defaultUnit'],
    );
  }
}

class Step {
  final int stepNumber;
  final String instruction;

  Step({
    required this.stepNumber,
    required this.instruction,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      stepNumber: json['stepNumber'],
      instruction: json['instruction'],
    );
  }
}