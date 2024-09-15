part of 'manage_user_bloc.dart';

@immutable
abstract class ManageUserEvent {
  const ManageUserEvent();
}

class Init extends ManageUserEvent {
  const Init({
    this.id,
  });

  final String? id;
}

class CreateUser extends ManageUserEvent {
  const CreateUser({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class UpdateUser extends ManageUserEvent {
  const UpdateUser({
    required this.name,
  });

  final String name;
}
