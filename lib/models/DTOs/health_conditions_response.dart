class HealthConditionsResponse {
  final int? healthConditionId;
  final String? healthConditionName;

  final String? briefDescription;

  final String? healthConditionType;

  HealthConditionsResponse({
    required this.healthConditionId,
    required this.healthConditionName,
    required this.briefDescription,
    required this.healthConditionType,
  });

  factory HealthConditionsResponse.fromJson(Map<String, dynamic> json) {
    return HealthConditionsResponse(
      healthConditionId: json['healthConditionId'],
      healthConditionName: json['healthConditionName'],
      briefDescription: json['briefDescription'],
      healthConditionType: json['healthConditionType'],
    );
  }

  static HealthConditionsResponse? safeFromJson(Map<String, dynamic> json) {
    try {
      if (json['healthConditionId'] == null ||
          json['healthConditionName'] == null ||
          json['briefDescription'] == null ||
          json['healthConditionType'] == null) {
        return null;
      }
      return HealthConditionsResponse.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
