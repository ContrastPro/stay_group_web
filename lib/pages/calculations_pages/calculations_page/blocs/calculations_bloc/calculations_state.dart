part of 'calculations_bloc.dart';

@immutable
class CalculationsState {
  const CalculationsState({
    this.status = BlocStatus.initial,
    this.calculations = const [],
  });

  final BlocStatus status;
  final List<CalculationModel> calculations;

  CalculationsState copyWith({
    BlocStatus? status,
    List<CalculationModel>? calculations,
  }) {
    return CalculationsState(
      status: status ?? this.status,
      calculations: calculations ?? this.calculations,
    );
  }
}
