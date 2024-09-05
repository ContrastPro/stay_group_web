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
    this.companyId,
    this.projectId,
    required this.section,
    required this.floor,
    required this.number,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.total,
    required this.living,
    required this.name,
    required this.description,
    required this.price,
    required this.depositVal,
    required this.depositPct,
    this.period,
    this.startInstallments,
    this.endInstallments,
  });

  final String? companyId;
  final String? projectId;
  final String section;
  final String floor;
  final String number;
  final String type;
  final String rooms;
  final String bathrooms;
  final String total;
  final String living;
  final String name;
  final String description;
  final String price;
  final String depositVal;
  final String depositPct;
  final int? period;
  final DateTime? startInstallments;
  final DateTime? endInstallments;
}

class UpdateCalculation extends ManageCalculationEvent {
  const UpdateCalculation({
    required this.id,
    this.companyId,
    this.projectId,
    required this.section,
    required this.floor,
    required this.number,
    required this.type,
    required this.rooms,
    required this.bathrooms,
    required this.total,
    required this.living,
    required this.name,
    required this.description,
    required this.price,
    required this.depositVal,
    required this.depositPct,
    this.period,
    this.startInstallments,
    this.endInstallments,
    required this.createdAt,
  });

  final String id;
  final String? companyId;
  final String? projectId;
  final String section;
  final String floor;
  final String number;
  final String type;
  final String rooms;
  final String bathrooms;
  final String total;
  final String living;
  final String name;
  final String description;
  final String price;
  final String depositVal;
  final String depositPct;
  final int? period;
  final DateTime? startInstallments;
  final DateTime? endInstallments;
  final String createdAt;
}
