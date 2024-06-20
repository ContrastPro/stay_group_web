import 'package:flutter/material.dart';

import '../../../widgets/navigation/flexible_layout.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  static const routeName = '/account_settings_pages/account_settings';

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return FlexibleLayout(
      builder: (Size size) {
        return const Center(
          child: Text('Account Settings Page'),
        );
      },
    );
  }
}
