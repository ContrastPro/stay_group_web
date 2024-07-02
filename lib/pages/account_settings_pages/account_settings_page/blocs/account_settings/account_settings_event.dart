part of 'account_settings_bloc.dart';

@immutable
sealed class AccountSettingsEvent {
  const AccountSettingsEvent();
}

class GetAccountInfo extends AccountSettingsEvent {
  const GetAccountInfo();
}

class SignOut extends AccountSettingsEvent {
  const SignOut();
}
