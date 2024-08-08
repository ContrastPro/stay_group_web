import 'calculation_info_model.dart';
import 'calculation_metadata_model.dart';

class CalculationModel {
  const CalculationModel({
    required this.id,
    required this.info,
    required this.metadata,
  });

  factory CalculationModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationModel(
      id: json['id'],
      info: CalculationInfoModel.fromJson(json['info']),
      metadata: CalculationMetadataModel.fromJson(json['metadata']),
    );
  }

  final String id;
  final CalculationInfoModel info;
  final CalculationMetadataModel metadata;
}
