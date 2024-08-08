import 'company_model.dart';

class CompanyResponseModel {
  const CompanyResponseModel({
    required this.companies,
  });

  factory CompanyResponseModel.fromJson(Map<Object?, dynamic> json) {
    return CompanyResponseModel(
      companies: json.values.map((e) => CompanyModel.fromJson(e)).toList(),
    );
  }

  final List<CompanyModel> companies;
}
