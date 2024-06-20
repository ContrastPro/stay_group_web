import 'package:flutter/material.dart';

import '../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../pages/building_companies_pages/building_companies_page/building_companies_pages.dart';
import '../pages/main_page.dart';
import '../pages/projects_pages/projects_page/projects_page.dart';
import '../pages/team_pages/team_page/team_page.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Object? arguments = settings.arguments;

    WidgetBuilder builder;

    switch (settings.name) {
      // [START] Building companies pages

      case BuildingCompaniesPage.routeName:
        builder = (_) => const BuildingCompaniesPage();
        break;

      // [END] Building companies pages

      // [START] Projects pages

      case ProjectsPage.routeName:
        builder = (_) => const ProjectsPage();
        break;

      // [END] Projects pages

      // [START] Team pages

      case TeamPage.routeName:
        builder = (_) => const TeamPage();
        break;

      // [END] Team pages

      // [START] Account settings pages

      case AccountSettingsPage.routeName:
        builder = (_) => const AccountSettingsPage();
        break;

      // [END] Account settings pages

      case MainPage.routeName:
        builder = (_) => const MainPage();
        break;

      default:
        throw Exception('Invalid route: ${settings.name}');
    }

    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}
