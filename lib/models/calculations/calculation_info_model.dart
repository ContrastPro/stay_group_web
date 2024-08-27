class CalculationInfoModel {
  const CalculationInfoModel({
    required this.companyId,
    required this.projectId,
    required this.name,
  });

  factory CalculationInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationInfoModel(
      companyId: json['companyId'],
      projectId: json['projectId'],
      name: json['name'],
    );
  }

  final String companyId;
  final String projectId;
  final String name;
}
