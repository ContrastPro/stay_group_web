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
              navigateToLogInPage: () => context.go(
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
            child: RestorePasswordPage(
              navigateToRestoreEmailPage: (String email) => context.go(
                RestoreEmailPage.routePath,
                extra: email,
              ),
              navigateToLogInPage: () => context.go(
                LogInPage.routePath,
              ),
            ),
          ),
        ),

        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: RestoreEmailPage.routePath,
          pageBuilder: (context, state) {
            final String args = state.extra as String;

            return _customTransition(
              state: state,
              child: RestoreEmailPage(
                email: args,
                navigateToLogInPage: () => context.go(
                  LogInPage.routePath,
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
              navigateToVerifyEmailPage: (String email) => context.go(
                VerifyEmailPage.routePath,
                extra: email,
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
          pageBuilder: (context, state) {
            final String args = state.extra as String;

            return _customTransition(
              state: state,
              child: VerifyEmailPage(
                email: args,
                navigateToLogInPage: () => context.go(
                  LogInPage.routePath,
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
            navigateToLogInPage: () => context.go(
              LogInPage.routePath,
            ),
            navigateToPricingPage: () => context.go(
              LogInPage.routePath,
            ),
            onSelectTab: context.go,
          ),
          routes: [
            // [START] Dashboard pages

            GoRoute(
              path: DashboardPage.routePath,
              pageBuilder: (context, state) => _customTransition(
                state: state,
                child: DashboardPage(
                  state: state,
                  navigateToManageCompanyPage: (
                    ManageCompanyPageArguments extra,
                  ) {
                    context.go(
                      ManageCompanyPage.routePath,
                      extra: extra,
                    );
                  },
                ),
              ),
            ),

            GoRoute(
              path: ManageCompanyPage.routePath,
              pageBuilder: (context, state) {
                final ManageCompanyPageArguments args =
                    state.extra as ManageCompanyPageArguments;

                return _customTransition(
                  state: state,
                  child: ManageCompanyPage(
                    count: args.count,
                    company: args.company,
                    navigateToMediaViewerPage: (
                      MediaViewerPageArguments extra,
                    ) {
                      context.push(
                        MediaViewerPage.routePath,
                        extra: extra,
                      );
                    },
                    navigateToDashboardPage: () => context.go(
                      DashboardPage.routePath,
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
                  navigateToManageProjectPage: (
                    ManageProjectPageArguments extra,
                  ) {
                    context.go(
                      ManageProjectPage.routePath,
                      extra: extra,
                    );
                  },
                ),
              ),
            ),

            GoRoute(
              path: ManageProjectPage.routePath,
              pageBuilder: (context, state) {
                final ManageProjectPageArguments args =
                    state.extra as ManageProjectPageArguments;

                return _customTransition(
                  state: state,
                  child: ManageProjectPage(
                    count: args.count,
                    project: args.project,
                    navigateToMediaViewerPage: (
                      MediaViewerPageArguments extra,
                    ) {
                      context.push(
                        MediaViewerPage.routePath,
                        extra: extra,
                      );
                    },
                    navigateToProjectsPage: () => context.go(
                      ProjectsPage.routePath,
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
                  navigateToManageUserPage: (
                    ManageUserPageArguments extra,
                  ) {
                    context.go(
                      ManageUserPage.routePath,
                      extra: extra,
                    );
                  },
                ),
              ),
            ),

            GoRoute(
              path: ManageUserPage.routePath,
              pageBuilder: (context, state) {
                final ManageUserPageArguments args =
                    state.extra as ManageUserPageArguments;

                return _customTransition(
                  state: state,
                  child: ManageUserPage(
                    count: args.count,
                    userData: args.userData,
                    navigateToTeamPage: () => context.go(
                      TeamPage.routePath,
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
                  navigateToManageCalculationPage: (
                    ManageCalculationPageArguments extra,
                  ) {
                    context.go(
                      ManageCalculationPage.routePath,
                      extra: extra,
                    );
                  },
                ),
              ),
            ),

            GoRoute(
              path: ManageCalculationPage.routePath,
              pageBuilder: (context, state) {
                final ManageCalculationPageArguments args =
                    state.extra as ManageCalculationPageArguments;

                return _customTransition(
                  state: state,
                  child: ManageCalculationPage(
                    count: args.count,
                    calculation: args.calculation,
                    navigateToCalculationsPage: () => context.go(
                      CalculationsPage.routePath,
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
