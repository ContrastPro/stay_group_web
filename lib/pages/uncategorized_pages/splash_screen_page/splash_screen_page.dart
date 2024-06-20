import 'dart:async';
import 'package:flutter/material.dart';

import '../../../resources/app_text_styles.dart';
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
                const Spacer(),
                Text(
                  'STAY GROUP',
                  style: AppTextStyles.head1Bold,
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
