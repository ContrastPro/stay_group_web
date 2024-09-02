part of 'account_settings_bloc.dart';

@immutable
abstract class AccountSettingsEvent {
  const AccountSettingsEvent();
}

class Init extends AccountSettingsEvent {
  const Init();
}

class UpdateAccountInfo extends AccountSettingsEvent {
  const UpdateAccountInfo({
    required this.name,
    required this.phone,
  });

  final String name;
  final String phone;
}
