class CompanyMetadataModel {
  const CompanyMetadataModel({
    required this.createdAt,
  });

  factory CompanyMetadataModel.fromJson(Map<Object?, dynamic> json) {
    return CompanyMetadataModel(
      createdAt: json['createdAt'],
    );
  }

  final String createdAt;
}
