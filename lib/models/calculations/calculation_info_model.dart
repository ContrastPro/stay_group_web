class CalculationInfoModel {
  const CalculationInfoModel({
    required this.name,
    required this.description,
  });

  factory CalculationInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationInfoModel(
      name: json['name'],
      description: json['description'],
    );
  }

  final String name;
  final String description;
}
