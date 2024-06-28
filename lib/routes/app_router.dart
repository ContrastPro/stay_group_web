import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../pages/auth_pages/log_in_page/log_in_page.dart';
import '../pages/auth_pages/restore_password_page/restore_password_page.dart';
import '../pages/auth_pages/sign_up_page/sign_up_page.dart';
import '../pages/auth_pages/verify_email_page/verify_email_page.dart';
import '../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../pages/main_page.dart';
import '../pages/projects_pages/projects_page/projects_page.dart';
import '../pages/team_pages/team_page/team_page.dart';
import '../pages/uncategorized_pages/splash_page/splash_page.dart';

class AppRouter {
  const AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final _shellDashboardNavigator = GlobalKey<NavigatorState>();
  static final _shellProjectsNavigator = GlobalKey<NavigatorState>();
  static final _shellTeamNavigator = GlobalKey<NavigatorState>();
  static final _shellSettingsNavigator = GlobalKey<NavigatorState>();

  static GoRouter generateRoute() {
    return GoRouter(
      observers: [
        BotToastNavigatorObserver(),
      ],
      navigatorKey: _rootNavigatorKey,
      initialLocation: SplashPage.routePath,
      routes: [
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: SplashPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: SplashPage(
              navigateToSignInPage: () => context.go(
                LogInPage.routePath,
              ),
              navigateToDashboardPage: () => context.go(
                DashboardPage.routePath,
              ),
            ),
          ),
        ),

        // [START] Auth pages

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: LogInPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: LogInPage(
              navigateToRestorePasswordPage: () => context.go(
                RestorePasswordPage.routePath,
              ),
              navigateToDashboardPage: () => context.go(
                DashboardPage.routePath,
              ),
              navigateToSignUpPage: () => context.go(
                SignUpPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RestorePasswordPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: const RestorePasswordPage(),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: SignUpPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: SignUpPage(
              navigateToVerifyEmailPage: () => context.go(
                VerifyEmailPage.routePath,
              ),
              navigateToLogInPage: () => context.go(
                LogInPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: VerifyEmailPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: const VerifyEmailPage(),
          ),
        ),

        // [END] Auth pages

        // [START] Main pages

        StatefulShellRoute.indexedStack(
          builder: (context, _, StatefulNavigationShell pageBuilder) {
            return MainPage(
              pageBuilder: pageBuilder,
              onSelectTab: context.go,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellDashboardNavigator,
              routes: [
                GoRoute(
                  path: DashboardPage.routePath,
                  pageBuilder: (context, state) => _customTransition(
                    state: state,
                    child: const DashboardPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellProjectsNavigator,
              routes: [
                GoRoute(
                  path: ProjectsPage.routePath,
                  pageBuilder: (context, state) => _customTransition(
                    state: state,
                    child: const ProjectsPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellTeamNavigator,
              routes: [
                GoRoute(
                  path: TeamPage.routePath,
                  pageBuilder: (context, state) => _customTransition(
                    state: state,
                    child: const TeamPage(),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellSettingsNavigator,
              routes: [
                GoRoute(
                  path: AccountSettingsPage.routePath,
                  pageBuilder: (context, state) => _customTransition(
                    state: state,
                    child: const AccountSettingsPage(),
                  ),
                ),
              ],
            ),
          ],
        ),

        // [END] Main pages
      ],
    );
  }

  static CustomTransitionPage _customTransition<T>({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
