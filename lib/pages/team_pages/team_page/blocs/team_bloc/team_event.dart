part of 'team_bloc.dart';

@immutable
abstract class TeamEvent {
  const TeamEvent();
}

class CreateEmailUser extends TeamEvent {
  const CreateEmailUser({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
