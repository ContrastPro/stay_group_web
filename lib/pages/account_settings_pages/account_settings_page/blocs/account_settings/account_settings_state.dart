part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  const AccountSettingsState({
    this.status = BlocStatus.initial,
    this.user,
  });

  final BlocStatus status;
  final UserModel? user;

  AccountSettingsState copyWith({
    BlocStatus? status,
    UserModel? user,
  }) {
    return AccountSettingsState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
