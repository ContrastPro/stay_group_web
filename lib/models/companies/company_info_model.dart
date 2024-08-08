class CompanyInfoModel {
  const CompanyInfoModel({
    required this.name,
    required this.description,
  });

  factory CompanyInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CompanyInfoModel(
      name: json['name'],
      description: json['description'],
    );
  }

  final String name;
  final String description;
}
