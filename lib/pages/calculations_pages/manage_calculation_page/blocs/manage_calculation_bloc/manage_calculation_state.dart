part of 'manage_calculation_bloc.dart';

@immutable
class ManageCalculationState {
  const ManageCalculationState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  ManageCalculationState copyWith({
    BlocStatus? status,
  }) {
    return ManageCalculationState(
      status: status ?? this.status,
    );
  }
}
