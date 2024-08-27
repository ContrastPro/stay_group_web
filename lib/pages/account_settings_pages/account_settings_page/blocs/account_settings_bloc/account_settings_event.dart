part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsEvent {
  const AccountSettingsEvent();
}

class Init extends AccountSettingsEvent {
  const Init();
}

class SignOut extends AccountSettingsEvent {
  const SignOut();
}
