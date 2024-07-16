part of 'team_bloc.dart';

@immutable
class TeamState {
  const TeamState({
    this.status = BlocStatus.initial,
    this.users = const [],
  });

  final BlocStatus status;
  final List<UserModel> users;

  TeamState copyWith({
    BlocStatus? status,
    List<UserModel>? users,
  }) {
    return TeamState(
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }
}
