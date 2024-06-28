part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class EmailLogIn extends AuthEvent {
  const EmailLogIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class EmailSignUp extends AuthEvent {
  const EmailSignUp({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class PasswordRecovery extends AuthEvent {
  const PasswordRecovery({
    required this.email,
  });

  final String email;
}
