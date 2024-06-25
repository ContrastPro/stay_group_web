import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

      final GoRouter routerConfig = AppRouter.generateRoute();

      runApp(
        _App(
          routerConfig: routerConfig,
        ),
      );
    },
    _errorHandler,
  );
}

class _App extends StatelessWidget {
  const _App({
    required this.routerConfig,
  });

  final GoRouter routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'STAY GROUP',
      theme: AppThemes.light(),
      builder: BotToastInit(),
      routerConfig: routerConfig,
    );
  }
}
