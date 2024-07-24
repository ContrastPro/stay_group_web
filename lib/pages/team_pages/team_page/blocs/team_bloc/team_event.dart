part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {
  const TeamEvent();
}

class GetUsers extends TeamEvent {
  const GetUsers();
}

class SwitchUserArchive extends TeamEvent {
  const SwitchUserArchive({
    required this.id,
    required this.archived,
  });

  final String id;
  final bool archived;
}
