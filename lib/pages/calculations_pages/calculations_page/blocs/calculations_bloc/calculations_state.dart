part of 'calculations_bloc.dart';

@immutable
class CalculationsState {
  const CalculationsState({
    this.status = BlocStatus.initial,
    this.userData,
    this.calculations = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final List<CalculationModel> calculations;

  CalculationsState copyWith({
    BlocStatus? status,
    UserModel? userData,
    List<CalculationModel>? calculations,
  }) {
    return CalculationsState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      calculations: calculations ?? this.calculations,
    );
  }
}
