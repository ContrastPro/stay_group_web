import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../pages/auth_pages/log_in_page/log_in_page.dart';
import '../pages/auth_pages/restore_email_page/restore_email_page.dart';
import '../pages/auth_pages/restore_password_page/restore_password_page.dart';
import '../pages/auth_pages/sign_up_page/sign_up_page.dart';
import '../pages/auth_pages/verify_email_page/verify_email_page.dart';
import '../pages/calculations_pages/calculations_page/calculations_page.dart';
import '../pages/calculations_pages/manage_calculation_page/manage_calculation_page.dart';
import '../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../pages/dashboard_pages/manage_company_page/manage_company_page.dart';
import '../pages/main_page.dart';
import '../pages/projects_pages/manage_project_page/manage_project_page.dart';
import '../pages/projects_pages/projects_page/projects_page.dart';
import '../pages/team_pages/manage_user_page/manage_user_page.dart';
import '../pages/team_pages/team_page/team_page.dart';
import '../pages/uncategorized_pages/media_viewer_page/media_viewer_page.dart';
import '../pages/uncategorized_pages/splash_page/splash_page.dart';

class AppRouter {
  const AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
              navigateToLogInPage: () => _go(
                context: context,
                routePath: LogInPage.routePath,
              ),
              navigateToDashboardPage: () => _go(
                context: context,
                routePath: DashboardPage.routePath,
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
              navigateToRestorePasswordPage: () => _go(
                context: context,
                routePath: RestorePasswordPage.routePath,
              ),
              navigateToDashboardPage: () => _go(
                context: context,
                routePath: DashboardPage.routePath,
              ),
              navigateToSignUpPage: () => _go(
                context: context,
                routePath: SignUpPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RestorePasswordPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: RestorePasswordPage(
              navigateToRestoreEmailPage: (String query) => _go(
                context: context,
                routePath: RestoreEmailPage.routePath,
                query: query,
              ),
              navigateToLogInPage: () => _go(
                context: context,
                routePath: LogInPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RestoreEmailPage.routePath,
          pageBuilder: (context, state) {
            final String? args = _query(state);

            return _customTransition(
              state: state,
              child: RestoreEmailPage(
                email: args,
                navigateToLogInPage: () => _go(
                  context: context,
                  routePath: LogInPage.routePath,
                ),
              ),
            );
          },
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: SignUpPage.routePath,
          pageBuilder: (context, state) => _customTransition(
            state: state,
            child: SignUpPage(
              navigateToVerifyEmailPage: (String query) => _go(
                context: context,
                routePath: VerifyEmailPage.routePath,
                query: query,
              ),
              navigateToLogInPage: () => _go(
                context: context,
                routePath: LogInPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: VerifyEmailPage.routePath,
          pageBuilder: (context, state) {
            final String? args = _query(state);

            return _customTransition(
              state: state,
              child: VerifyEmailPage(
                email: args,
                navigateToLogInPage: () => _go(
                  context: context,
                  routePath: LogInPage.routePath,
                ),
              ),
            );
          },
        ),

        // [END] Auth pages

        // [START] Main pages

        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, body) => MainPage(
            body: body,
            state: state,
            navigateToLogInPage: () => _go(
              context: context,
              routePath: LogInPage.routePath,
            ),
            navigateToPricingPage: () => _go(
              context: context,
              routePath: LogInPage.routePath,
            ),
            onSelectTab: (String routePath) => _go(
              context: context,
              routePath: routePath,
            ),
          ),
          routes: [
            // [START] Dashboard pages

            GoRoute(
              path: DashboardPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: DashboardPage(
                  state: state,
                  navigateToManageCompanyPage: ([String? query]) => _go(
                    context: context,
                    routePath: ManageCompanyPage.routePath,
                    query: query,
                  ),
                ),
              ),
            ),

            GoRoute(
              path: ManageCompanyPage.routePath,
              pageBuilder: (context, state) {
                final String? args = _query(state);

                return _customTransition(
                  state: state,
                  child: ManageCompanyPage(
                    id: args,
                    navigateToMediaViewerPage: (media) => _push(
                      context: context,
                      routePath: MediaViewerPage.routePath,
                      extra: media,
                    ),
                    navigateToDashboardPage: () => _go(
                      context: context,
                      routePath: DashboardPage.routePath,
                    ),
                  ),
                );
              },
            ),

            // [END] Dashboard pages

            // [START] Projects pages

            GoRoute(
              path: ProjectsPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: ProjectsPage(
                  state: state,
                  navigateToManageProjectPage: ([String? query]) => _go(
                    context: context,
                    routePath: ManageProjectPage.routePath,
                    query: query,
                  ),
                ),
              ),
            ),

            GoRoute(
              path: ManageProjectPage.routePath,
              pageBuilder: (context, state) {
                final String? args = _query(state);

                return _customTransition(
                  state: state,
                  child: ManageProjectPage(
                    id: args,
                    navigateToMediaViewerPage: (media) => _push(
                      context: context,
                      routePath: MediaViewerPage.routePath,
                      extra: media,
                    ),
                    navigateToProjectsPage: () => _go(
                      context: context,
                      routePath: ProjectsPage.routePath,
                    ),
                  ),
                );
              },
            ),

            // [END] Projects pages

            // [START] Team pages

            GoRoute(
              path: TeamPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: TeamPage(
                  state: state,
                  navigateToManageUserPage: ([String? query]) => _go(
                    context: context,
                    routePath: ManageUserPage.routePath,
                    query: query,
                  ),
                ),
              ),
            ),

            GoRoute(
              path: ManageUserPage.routePath,
              pageBuilder: (context, state) {
                final String? args = _query(state);

                return _customTransition(
                  state: state,
                  child: ManageUserPage(
                    id: args,
                    navigateToTeamPage: () => _go(
                      context: context,
                      routePath: TeamPage.routePath,
                    ),
                  ),
                );
              },
            ),

            // [END] Team pages

            // [START] Calculations pages

            GoRoute(
              path: CalculationsPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: CalculationsPage(
                  state: state,
                  navigateToManageCalculationPage: ([String? query]) => _go(
                    context: context,
                    routePath: ManageCalculationPage.routePath,
                    query: query,
                  ),
                ),
              ),
            ),

            GoRoute(
              path: ManageCalculationPage.routePath,
              pageBuilder: (context, state) {
                final String? args = _query(state);

                return _customTransition(
                  state: state,
                  child: ManageCalculationPage(
                    id: args,
                    navigateToCalculationsPage: () => _go(
                      context: context,
                      routePath: CalculationsPage.routePath,
                    ),
                  ),
                );
              },
            ),

            // [END] Calculations pages

            // [START] Account settings pages

            GoRoute(
              path: AccountSettingsPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: AccountSettingsPage(
                  state: state,
                ),
              ),
            ),

            // [END] Account settings pages
          ],
        ),

        // [END] Main pages

        // [START] Uncategorized pages

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: MediaViewerPage.routePath,
          pageBuilder: (context, state) {
            final MediaViewerPageArguments args =
                state.extra as MediaViewerPageArguments;

            return _customTransition(
              state: state,
              child: MediaViewerPage(
                index: args.index,
                media: args.media,
                navigateBack: context.pop,
              ),
            );
          },
        ),

        // [END] Uncategorized pages
      ],
    );
  }

  static void _go({
    required BuildContext context,
    required String routePath,
    String? query,
  }) {
    if (query == null) {
      return context.go(routePath);
    }

    return context.go(
      '$routePath?data=$query',
    );
  }

  static Future<void> _push({
    required BuildContext context,
    required String routePath,
    Object? extra,
  }) {
    return context.push(routePath, extra: extra);
  }

  static String? _query(GoRouterState state) {
    final String? query = state.uri.queryParameters['data'];

    if (query != null) {
      final String data = query.trim();

      if (data.isNotEmpty) return data;

      return null;
    }

    return null;
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
