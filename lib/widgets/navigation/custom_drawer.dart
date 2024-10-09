import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../blocs/navigation_bloc/navigation_bloc.dart';
import '../../models/uncategorized/bottom_navigation_bar_item_model.dart';
import '../../models/users/user_info_model.dart';
import '../../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../../pages/calculations_pages/calculations_page/calculations_page.dart';
import '../../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../../pages/projects_pages/projects_page/projects_page.dart';
import '../../pages/team_pages/team_page/team_page.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';
import '../../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.fullPath,
    required this.screenSize,
  });

  final String? fullPath;
  final Size screenSize;

  static const List<BottomNavigationBarItemModel> _tabsManager = [
    BottomNavigationBarItemModel(
      icon: AppIcons.dashboard,
      title: 'Companies', //Dashboard
      routePath: DashboardPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.projects,
      title: 'Projects',
      routePath: ProjectsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.team,
      title: 'Team',
      routePath: TeamPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.calculation,
      title: 'Calculations',
      routePath: CalculationsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.settings,
      title: 'Account settings',
      routePath: AccountSettingsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.signOut,
      title: 'Logout',
      routePath: 'sign_out',
    ),
  ];

  static const List<BottomNavigationBarItemModel> _tabsWorker = [
    BottomNavigationBarItemModel(
      icon: AppIcons.dashboard,
      title: 'Companies', //Dashboard
      routePath: DashboardPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.projects,
      title: 'Projects',
      routePath: ProjectsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.calculation,
      title: 'Calculations',
      routePath: CalculationsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.settings,
      title: 'Account settings',
      routePath: AccountSettingsPage.routePath,
    ),
    BottomNavigationBarItemModel(
      icon: AppIcons.signOut,
      title: 'Logout',
      routePath: 'sign_out',
    ),
  ];

  void _onSelect({
    required BuildContext context,
    required String routePath,
  }) {
    if (routePath == 'sign_out') {
      return context.read<NavigationBloc>().add(
            const SignOut(),
          );
    }

    if (fullPath != routePath) {
      context.read<NavigationBloc>().add(
            NavigateTab(
              routePath: routePath,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (screenSize.width >= kTabletScreenWidth) {
          return _TextButton(
            state: state,
            fullPath: fullPath,
            tabs: state.userData!.info.role == UserRole.manager
                ? _tabsManager
                : _tabsWorker,
            onSelect: (String routePath) => _onSelect(
              context: context,
              routePath: routePath,
            ),
          );
        }

        return _IconButton(
          state: state,
          fullPath: fullPath,
          tabs: state.userData!.info.role == UserRole.manager
              ? _tabsManager
              : _tabsWorker,
          onSelect: (String routePath) => _onSelect(
            context: context,
            routePath: routePath,
          ),
        );
      },
    );
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({
    required this.state,
    required this.fullPath,
    required this.tabs,
    required this.onSelect,
  });

  final NavigationState state;
  final String? fullPath;
  final List<BottomNavigationBarItemModel> tabs;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.0,
      child: Column(
        children: tabs.map((e) {
          return Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: InkWell(
                onTap: () => onSelect(e.routePath),
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: e.routePath == fullPath
                        ? AppColors.scaffoldSecondary
                        : AppColors.transparent,
                    border: Border.all(
                      color: e.routePath == fullPath
                          ? AppColors.border
                          : AppColors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        e.icon,
                        width: 20.0,
                        colorFilter: ColorFilter.mode(
                          e.routePath == fullPath
                              ? AppColors.primary
                              : AppColors.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        e.title,
                        style: AppTextStyles.paragraphSRegular.copyWith(
                          color: e.routePath == fullPath
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.state,
    required this.fullPath,
    required this.tabs,
    required this.onSelect,
  });

  final NavigationState state;
  final String? fullPath;
  final List<BottomNavigationBarItemModel> tabs;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.0,
      child: Column(
        children: tabs.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: InkWell(
              onTap: () => onSelect(e.routePath),
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 10.0,
                ),
                decoration: BoxDecoration(
                  color: e.routePath == fullPath
                      ? AppColors.scaffoldSecondary
                      : AppColors.transparent,
                  border: Border.all(
                    color: e.routePath == fullPath
                        ? AppColors.border
                        : AppColors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SvgPicture.asset(
                  e.icon,
                  width: 20.0,
                  colorFilter: ColorFilter.mode(
                    e.routePath == fullPath
                        ? AppColors.primary
                        : AppColors.secondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
