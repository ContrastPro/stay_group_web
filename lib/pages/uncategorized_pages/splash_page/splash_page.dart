import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repositories/auth_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/animations/fade_in_animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.navigateToSignInPage,
    required this.navigateToDashboardPage,
  });

  static const routePath = '/';

  final void Function() navigateToSignInPage;
  final void Function() navigateToDashboardPage;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _setInitialData();
    super.initState();
  }

  void _setInitialData() {
    Timer(
      const Duration(
        milliseconds: 3000,
      ),
      () {
        final AuthRepository repository = context.read<AuthRepository>();
        final User? user = repository.currentUser();

        if (user != null) {
          if (!user.emailVerified) {
            return widget.navigateToSignInPage();
          }

          return widget.navigateToDashboardPage();
        }

        return widget.navigateToSignInPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInAnimation(
        duration: const Duration(
          milliseconds: 1500,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 64.0,
                    ),
                    child: AutoSizeText(
                      'STAY GROUP',
                      style: AppTextStyles.head1Bold.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
