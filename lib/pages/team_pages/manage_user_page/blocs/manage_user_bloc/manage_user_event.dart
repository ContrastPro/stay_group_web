part of 'manage_user_bloc.dart';

@immutable
abstract class ManageUserEvent {
  const ManageUserEvent();
}

class CreateWorker extends ManageUserEvent {
  const CreateWorker({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}
