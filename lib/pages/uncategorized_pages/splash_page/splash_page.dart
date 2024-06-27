import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
        milliseconds: 2000,
      ),
      () {
        //const bool isAuth = false;
        const bool isAuth = true;

        if (!isAuth) {
          return widget.navigateToSignInPage();
        }

        return widget.navigateToDashboardPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInAnimation(
        duration: const Duration(
          milliseconds: 3000,
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
