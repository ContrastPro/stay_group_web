import 'dart:async';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'database/local_database.dart';
import 'firebase_options.dart';
import 'repositories/auth_repository.dart';
import 'repositories/calculations_repository.dart';
import 'repositories/companies_repository.dart';
import 'repositories/projects_repository.dart';
import 'repositories/storage_repository.dart';
import 'repositories/users_repository.dart';
import 'resources/app_locale.dart';
import 'resources/app_themes.dart';
import 'routes/app_router.dart';

// todo: delete later
// staygroup.io@gmail.com
// glebon0202@gmail.com
// leojugaschvili@gmail.com

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

      await EasyLocalization.ensureInitialized();

      await LocalDB.instance.ensureInitialized();

      final GoRouter routerConfig = AppRouter.generateRoute();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(
        EasyLocalization(
          path: AppLocale.path,
          supportedLocales: AppLocale.getSupportedLocales,
          fallbackLocale: AppLocale.fallbackLocale,
          child: _App(
            routerConfig: routerConfig,
          ),
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
  static final CalculationsRepository _calcRepo = CalculationsRepository();
  static final CompaniesRepository _companiesRepository = CompaniesRepository();
  static final ProjectsRepository _projectsRepository = ProjectsRepository();
  static final StorageRepository _storageRepository = StorageRepository();
  static final UsersRepository _usersRepository = UsersRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => _authRepository,
        ),
        RepositoryProvider<CalculationsRepository>(
          create: (_) => _calcRepo,
        ),
        RepositoryProvider<CompaniesRepository>(
          create: (_) => _companiesRepository,
        ),
        RepositoryProvider<ProjectsRepository>(
          create: (_) => _projectsRepository,
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => _storageRepository,
        ),
        RepositoryProvider<UsersRepository>(
          create: (_) => _usersRepository,
        ),
      ],
      child: MaterialApp.router(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        title: 'STAY GROUP',
        theme: AppThemes.light(),
        routerConfig: routerConfig,
        builder: BotToastInit(),
      ),
    );
  }
}
