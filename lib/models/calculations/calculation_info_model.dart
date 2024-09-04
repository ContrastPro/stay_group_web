class CalculationInfoModel {
  const CalculationInfoModel({
    this.companyId,
    this.projectId,
    required this.name,
    this.description,
  });

  factory CalculationInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationInfoModel(
      companyId: json['companyId'],
      projectId: json['projectId'],
      name: json['name'],
      description: json['description'],
    );
  }

  final String? companyId;
  final String? projectId;
  final String name;
  final String? description;
}
