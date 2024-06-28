part of 'auth_bloc.dart';

@immutable
class AuthState {
  const AuthState({
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  final BlocStatus status;
  final String? errorMessage;

  AuthState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
