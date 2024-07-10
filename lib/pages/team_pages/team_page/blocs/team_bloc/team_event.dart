part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {
  const TeamEvent();
}

class GetUsers extends TeamEvent {
  const GetUsers();
}
