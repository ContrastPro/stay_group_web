part of 'manage_user_bloc.dart';

@immutable
class ManageUserState {
  const ManageUserState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.user,
    this.userData,
    this.users = const [],
  });

  final BlocStatus status;
  final String? errorMessage;
  final User? user;
  final UserModel? userData;
  final List<UserModel> users;

  ManageUserState copyWith({
    BlocStatus? status,
    String? errorMessage,
    User? user,
    UserModel? userData,
    List<UserModel>? users,
  }) {
    return ManageUserState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
      userData: userData ?? this.userData,
      users: users ?? this.users,
    );
  }
}
