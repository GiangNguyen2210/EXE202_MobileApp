class IngredientResponse {
  final int? ingredientId;
  final String? ingredientName;
  final String? defaultUnit;
  final String? iconLibrary;
  final String? iconName;

  IngredientResponse({
    required this.ingredientId,
    required this.ingredientName,
    required this.defaultUnit,
    required this.iconLibrary,
    required this.iconName,
  });

  factory IngredientResponse.fromJson(Map<String, dynamic> json) {
    return IngredientResponse(
      ingredientName: json['ingredientName'],
      ingredientId: json['ingredientId'],
      defaultUnit: json['defaultUnit'],
      iconLibrary: json['iconLibrary'] ?? '',
      iconName: json['iconName'] ?? '',
    );
  }

  static IngredientResponse? safeFromJson(Map<String, dynamic> json) {
    try {
      if (json['ingredientName'] == null ||
          json['ingredientId'] == null ||
          json['defaultUnit'] == null) {
        return null;
      }
      return IngredientResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
