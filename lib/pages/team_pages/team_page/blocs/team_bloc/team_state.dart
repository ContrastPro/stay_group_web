part of 'team_bloc.dart';

@immutable
class TeamState {
  const TeamState({
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  final BlocStatus status;
  final String? errorMessage;

  TeamState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) {
    return TeamState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
