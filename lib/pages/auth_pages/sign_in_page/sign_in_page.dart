import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../widgets/text_fields/border_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
    required this.navigateToSignUpPage,
  });

  static const routePath = '/auth_pages/sign_in';

  final void Function() navigateToSignUpPage;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 450,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldSecondary,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            children: [
              BorderTextField(
                labelText: 'Email',
                hintText: 'Placeholder',
                prefixIcon: AppIcons.mail,
              ),
              SizedBox(height: 16.0),
              BorderTextField(
                labelText: 'Password',
                hintText: 'Password',
                prefixIcon: AppIcons.lock,
                suffixIcon: AppIcons.visibilityOn,
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: widget.navigateToSignUpPage,
                child: Text('Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
