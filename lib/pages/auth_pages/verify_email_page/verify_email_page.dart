import 'package:flutter/material.dart';

import '../../../widgets/layouts/center_container_layout.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  static const routePath = '/auth_pages/verify_email';

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return const CenterContainerLayout(
      body: Center(
        child: Text('Verify Email Page'),
      ),
    );
  }
}
