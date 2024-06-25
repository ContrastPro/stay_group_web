import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../pages/auth_pages/sign_in_page/sign_in_page.dart';
import '../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../pages/main_page.dart';
import '../pages/projects_pages/projects_page/projects_page.dart';
import '../pages/team_pages/team_page/team_page.dart';
import '../pages/uncategorized_pages/splash_screen_page/splash_screen_page.dart';

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigator =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> _sectionNavigator =
      GlobalKey<NavigatorState>();

  static GoRouter generateRoute() {
    return GoRouter(
      observers: [
        BotToastNavigatorObserver(),
      ],
      navigatorKey: _rootNavigator,
      initialLocation: SplashScreenPage.routePath,
      routes: [
        // [START] Uncategorized pages

        GoRoute(
          path: SplashScreenPage.routePath,
          builder: (context, _) => SplashScreenPage(
            navigateToSignInPage: () => context.go(
              SignInPage.routePath,
            ),
            navigateToMainPage: () => context.go(
              DashboardPage.routePath,
            ),
          ),
        ),

        // [END] Uncategorized pages

        // [START] Auth pages

        GoRoute(
          path: SignInPage.routePath,
          builder: (context, _) => const SignInPage(),
        ),

        // [END] Auth pages

        StatefulShellRoute.indexedStack(
          builder: (context, _, StatefulNavigationShell pageBuilder) {
            return MainPage(
              pageBuilder: pageBuilder,
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _sectionNavigator,
              routes: [
                GoRoute(
                  path: DashboardPage.routePath,
                  builder: (context, _) => const DashboardPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ProjectsPage.routePath,
                  builder: (context, _) => const ProjectsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: TeamPage.routePath,
                  builder: (context, _) => const TeamPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AccountSettingsPage.routePath,
                  builder: (context, _) => const AccountSettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
