import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/local_database.dart';
import '../../../repositories/auth_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/animations/fade_in_animation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.navigateToLogInPage,
    required this.navigateToDashboardPage,
  });

  static const routePath = '/';

  final void Function() navigateToLogInPage;
  final void Function() navigateToDashboardPage;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const LocalDB _localDB = LocalDB.instance;

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
      () async {
        final AuthRepository repository = context.read<AuthRepository>();

        final Locale? locale = await _localDB.getLocale();

        if (!mounted) return;

        if (locale == null) {
          await _localDB.saveLocale(context.locale);
        }

        final User? user = repository.currentUser();

        if (user != null) {
          if (!user.emailVerified) {
            return widget.navigateToLogInPage();
          }

          return widget.navigateToDashboardPage();
        }

        return widget.navigateToLogInPage();
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
