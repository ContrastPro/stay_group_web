class CalculationMetadataModel {
  const CalculationMetadataModel({
    required this.createdAt,
  });

  factory CalculationMetadataModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationMetadataModel(
      createdAt: json['createdAt'],
    );
  }

  final String createdAt;
}
