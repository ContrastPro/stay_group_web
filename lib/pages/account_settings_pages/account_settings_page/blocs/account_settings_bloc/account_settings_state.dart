part of 'account_settings_bloc.dart';

@immutable
class AccountSettingsState {
  const AccountSettingsState({
    this.status = BlocStatus.initial,
    this.userData,
    this.spaceData,
  });

  final BlocStatus status;
  final UserModel? userData;
  final UserModel? spaceData;

  AccountSettingsState copyWith({
    BlocStatus? status,
    UserModel? userData,
    UserModel? spaceData,
  }) {
    return AccountSettingsState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      spaceData: spaceData ?? this.spaceData,
    );
  }
}
