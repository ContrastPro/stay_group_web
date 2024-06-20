import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'pages/uncategorized_pages/splash_screen_page/splash_screen_page.dart';
import 'resources/app_themes.dart';
import 'routes/app_router.dart';

void _errorHandler(Object error, StackTrace stack) {
  log(
    '\nError description: $error'
    '\nStackTrace:\n$stack',
    name: 'Error handler',
  );
}

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(
        const _App(),
      );
    },
    _errorHandler,
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
      debugShowCheckedModeBanner: false,
      title: 'STAY GROUP',
      theme: AppThemes.light(),
      initialRoute: SplashScreenPage.routeName,
      onGenerateRoute: AppRouter.generateRoute,
      routes: {
        SplashScreenPage.routeName: (_) => const SplashScreenPage(),
      },
    );
  }
}
