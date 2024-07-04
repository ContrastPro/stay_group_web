import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../blocs/navigation_bloc/navigation_bloc.dart';
import '../../models/uncategorized/bottom_navigation_bar_item_model.dart';
import '../../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../../pages/dashboard_pages/dashboard_page/dashboard_pages.dart';
import '../../pages/projects_pages/projects_page/projects_page.dart';
import '../../pages/team_pages/team_page/team_page.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.fullPath,
    required this.screenSize,
  });

  final String? fullPath;
  final Size screenSize;

  static const List<BottomNavigationBarItemModel> _tabs = [
    BottomNavigationBarItemModel(
      icon: AppIcons.dashboard,
      title: 'Dashboard',
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
      icon: AppIcons.settings,
      title: 'Account settings',
      routePath: AccountSettingsPage.routePath,
    ),
  ];

  void _onSelect({
    required BuildContext context,
    required String routePath,
  }) {
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
        if (screenSize.width >= 960.0) {
          return SizedBox(
            width: 240.0,
            child: Column(
              children: _tabs.map((e) {
                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap: () => _onSelect(
                        context: context,
                        routePath: e.routePath,
                      ),
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

        return SizedBox(
          width: 45.0,
          child: Column(
            children: _tabs.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: InkWell(
                  onTap: () => _onSelect(
                    context: context,
                    routePath: e.routePath,
                  ),
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
      },
    );
  }
}
