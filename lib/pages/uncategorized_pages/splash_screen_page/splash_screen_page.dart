import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_text_styles.dart';
import '../../../widgets/animations/fade_in_animation.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({
    super.key,
    required this.navigateToSignInPage,
    required this.navigateToMainPage,
  });

  static const routePath = '/';

  final void Function() navigateToSignInPage;
  final void Function() navigateToMainPage;

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
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
        const bool isAuth = true;

        if (!isAuth) {
          return widget.navigateToSignInPage();
        }

        return widget.navigateToMainPage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInAnimation(
        duration: const Duration(
          milliseconds: 2000,
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
