import 'company_info_model.dart';
import 'company_metadata_model.dart';

class CompanyModel {
  const CompanyModel({
    required this.id,
    required this.info,
    required this.metadata,
  });

  factory CompanyModel.fromJson(Map<Object?, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      info: CompanyInfoModel.fromJson(json['info']),
      metadata: CompanyMetadataModel.fromJson(json['metadata']),
    );
  }

  final String id;
  final CompanyInfoModel info;
  final CompanyMetadataModel metadata;
}
