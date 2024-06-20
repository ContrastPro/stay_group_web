import 'dart:async';
import 'package:flutter/material.dart';

import '../../../resources/app_colors.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../main_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  static const routeName = '/';

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
        return _navigateToPage(
          MainPage.routeName,
        );
      },
    );
  }

  void _navigateToPage(
    String route, {
    Object? arguments,
  }) {
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      route,
      (_) => false,
      arguments: arguments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FadeInAnimation(
        duration: Duration(
          milliseconds: 2000,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  'STAY GROUP',
                  style: TextStyle(
                    fontSize: 38.0,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
