import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'database/local_database.dart';
import 'firebase_options.dart';
import 'repositories/auth_repository.dart';
import 'repositories/users_repository.dart';
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

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocalDB.instance.ensureInitialized();

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

  static final AuthRepository _authRepository = AuthRepository();
  static final UsersRepository _usersRepository = UsersRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
        RepositoryProvider<UsersRepository>(
          create: (_) => _usersRepository,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'STAY GROUP',
        theme: AppThemes.light(),
        routerConfig: routerConfig,
        builder: BotToastInit(),
      ),
    );
  }
}
