part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {
  const TeamEvent();
}

class Init extends TeamEvent {
  const Init();
}

class DeleteUser extends TeamEvent {
  const DeleteUser({
    required this.id,
    required this.email,
  });

  final String id;
  final String email;
}

class SwitchUserArchive extends TeamEvent {
  const SwitchUserArchive({
    required this.id,
    required this.archived,
  });

  final String id;
  final bool archived;
}
