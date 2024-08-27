part of 'manage_calculation_bloc.dart';

@immutable
abstract class ManageCalculationEvent {
  const ManageCalculationEvent();
}

class Init extends ManageCalculationEvent {
  const Init();
}

class CreateCalculation extends ManageCalculationEvent {
  const CreateCalculation({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UpdateCalculation extends ManageCalculationEvent {
  const UpdateCalculation({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}
