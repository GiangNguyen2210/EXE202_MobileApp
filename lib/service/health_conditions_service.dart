import 'package:exe202_mobile_app/models/DTOs/health_conditions_response.dart';

class HCService {
  HCItem mapResponseToHCItem(HealthConditionsResponse dto) {
    final String hcname = dto.healthConditionName ?? 'a';
    final int id = dto.healthConditionId ?? 0;

    return HCItem(hcname: hcname, id: id);
  }

  List<HCItem> parseResponseToHCItem(List<HealthConditionsResponse> dtoList) {
    return dtoList.map((dto) => mapResponseToHCItem(dto)).toList();
  }
}

class HCItem {
  final String? hcname;
  final int? id;
  bool a;

  HCItem({this.hcname, this.id, this.a = false});
}
