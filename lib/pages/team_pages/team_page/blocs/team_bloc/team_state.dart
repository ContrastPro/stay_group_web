part of 'team_bloc.dart';

@immutable
class TeamState {
  const TeamState({
    this.status = BlocStatus.initial,
  });

  final BlocStatus status;

  TeamState copyWith({
    BlocStatus? status,
  }) {
    return TeamState(
      status: status ?? this.status,
    );
  }
}
