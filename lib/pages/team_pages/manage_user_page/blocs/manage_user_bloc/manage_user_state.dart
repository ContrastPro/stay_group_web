part of 'manage_user_bloc.dart';

@immutable
class ManageUserState {
  const ManageUserState({
    this.status = BlocStatus.initial,
    this.errorMessage,
  });

  final BlocStatus status;
  final String? errorMessage;

  ManageUserState copyWith({
    BlocStatus? status,
    String? errorMessage,
  }) {
    return ManageUserState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
