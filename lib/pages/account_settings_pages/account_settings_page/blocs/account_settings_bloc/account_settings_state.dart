part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  const AccountSettingsState({
    this.status = BlocStatus.initial,
    this.userData,
  });

  final BlocStatus status;
  final UserModel? userData;

  AccountSettingsState copyWith({
    BlocStatus? status,
    UserModel? userData,
  }) {
    return AccountSettingsState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
    );
  }
}
