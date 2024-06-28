import 'package:flutter/material.dart';

import '../../../widgets/layouts/center_container_layout.dart';

class RestorePasswordPage extends StatefulWidget {
  const RestorePasswordPage({super.key});

  static const routePath = '/auth_pages/restore_password';

  @override
  State<RestorePasswordPage> createState() => _RestorePasswordPageState();
}

class _RestorePasswordPageState extends State<RestorePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return const CenterContainerLayout(
      body: Center(
        child: Text('Restore Password Page'),
      ),
    );
  }
}
