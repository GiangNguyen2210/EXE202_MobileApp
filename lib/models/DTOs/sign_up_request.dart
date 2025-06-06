class SignUpRequestDTO {
  late int? weight;
  late int? goalWeight;
  late double? height;
  late String? gender;
  late int? age;
  late int? goalId;
  late final MealScheduledDTO mealScheduledDTO;
  late List<int>? listAllergies;

  SignUpRequestDTO({
    this.weight,
    this.goalWeight,
    this.height,
    this.gender,
    this.age,
    this.goalId,
    required this.mealScheduledDTO,
    this.listAllergies,
  });

  factory SignUpRequestDTO.fromJson(Map<String, dynamic> json) {
    return SignUpRequestDTO(
      weight: json['weight'],
      goalWeight: json['goalWeight'],
      height: json['height'],
      gender: json['gender'],
      age: json['age'],
      goalId: json['goalId'],
      mealScheduledDTO: json['a'],
    );
  }

  static SignUpRequestDTO? safeFromJson(Map<String, dynamic> json) {
    try {
      if (json['weight'] == null ||
          json['goalWeight'] == null ||
          json['height'] == null ||
          json['gender'] == null ||
          json['age'] == null ||
          json['goalId'] == null) {
        return null;
      }
      return SignUpRequestDTO.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() {
    return 'SignUpRequestDTO{'
        'weight: $weight, '
        'goalWeight: $goalWeight, '
        'height: $height, '
        'gender: $gender, '
        'age: $age, '
        'goalId: $goalId, '
        'mealScheduledDTO: ${mealScheduledDTO.toString()}, '
        'listAllergies: $listAllergies'
        '}';
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class GoalsResponseDTO {
  final int? goalId;
  final String? goalName;

  GoalsResponseDTO({required this.goalId, required this.goalName});

  factory GoalsResponseDTO.fromJson(Map<String, dynamic> json) {
    return GoalsResponseDTO(goalId: json['goalId'], goalName: json['goalName']);
  }

  static GoalsResponseDTO? safeFromJson(Map<String, dynamic> json) {
    try {
      if (json['goalId'] == null || json['goalName'] == null) {
        return null;
      }
      return GoalsResponseDTO.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class MealScheduledDTO {
  late String? BreakFastTime;
  late String? LunchTime;
  late String? DinnerTime;

  MealScheduledDTO({this.BreakFastTime, this.LunchTime, this.DinnerTime});

  @override
  String toString() {
    return 'MealScheduledDTO{'
        'weight: $BreakFastTime, '
        'goalWeight: $LunchTime, '
        'height: $DinnerTime, '
        '}';
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
