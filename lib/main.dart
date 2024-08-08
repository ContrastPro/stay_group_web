import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'repositories/auth_repository.dart';
import 'repositories/calculations_repository.dart';
import 'repositories/companies_repository.dart';
import 'repositories/projects_repository.dart';
import 'repositories/users_repository.dart';
import 'resources/app_themes.dart';
import 'routes/app_router.dart';

// todo: delete
// staygroup.io@gmail.com
// glebon0202@gmail.com

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
  static final CalculationsRepository _calculationsRepository =
      CalculationsRepository();
  static final CompaniesRepository _companiesRepository = CompaniesRepository();
  static final ProjectsRepository _projectsRepository = ProjectsRepository();
  static final UsersRepository _usersRepository = UsersRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
        RepositoryProvider<CalculationsRepository>(
          create: (_) => _calculationsRepository,
        ),
        RepositoryProvider<CompaniesRepository>(
          create: (_) => _companiesRepository,
        ),
        RepositoryProvider<ProjectsRepository>(
          create: (_) => _projectsRepository,
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
