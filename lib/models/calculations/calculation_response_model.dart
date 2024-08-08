import 'calculation_model.dart';

class CalculationResponseModel {
  const CalculationResponseModel({
    required this.calculations,
  });

  factory CalculationResponseModel.fromJson(Map<Object?, dynamic> json) {
    return CalculationResponseModel(
      calculations:
          json.values.map((e) => CalculationModel.fromJson(e)).toList(),
    );
  }

  final List<CalculationModel> calculations;
}
