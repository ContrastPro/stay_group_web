import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../blocs/navigation_bloc/navigation_bloc.dart';
import '../../models/uncategorized/custom_bottom_navigation_bar_item_model.dart';
import '../../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../../pages/building_companies_pages/building_companies_page/building_companies_pages.dart';
import '../../pages/projects_pages/projects_page/projects_page.dart';
import '../../pages/team_pages/team_page/team_page.dart';
import '../../resources/app_colors.dart';
import '../../resources/app_icons.dart';
import '../../resources/app_text_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.screenSize,
  });

  final Size screenSize;

  static const List<String> _pages = [
    BuildingCompaniesPage.routeName,
    ProjectsPage.routeName,
    TeamPage.routeName,
    AccountSettingsPage.routeName,
  ];

  static const List<CustomBottomNavigationBarItemModel> _tabs = [
    CustomBottomNavigationBarItemModel(
      icon: AppIcons.dashboard,
      title: 'Dashboard',
    ),
    CustomBottomNavigationBarItemModel(
      icon: AppIcons.projects,
      title: 'Projects',
    ),
    CustomBottomNavigationBarItemModel(
      icon: AppIcons.team,
      title: 'Team',
    ),
    CustomBottomNavigationBarItemModel(
      icon: AppIcons.settings,
      title: 'Account settings',
    ),
  ];

  void _onSelect({
    required BuildContext context,
    required int currentTab,
    required int index,
  }) {
    if (currentTab != index) {
      context.read<NavigationBloc>().add(
            NavigateTab(
              index: index,
              route: _pages[index],
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
              children: _tabs.map((i) {
                final int index = _tabs.indexOf(i);

                return Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap: () => _onSelect(
                        context: context,
                        currentTab: state.currentTab,
                        index: index,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: index == state.currentTab
                              ? AppColors.scaffoldSecondary
                              : AppColors.transparent,
                          border: Border.all(
                            color: index == state.currentTab
                                ? AppColors.border
                                : AppColors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              i.icon,
                              width: 20.0,
                              colorFilter: ColorFilter.mode(
                                index == state.currentTab
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              i.title,
                              style: AppTextStyles.paragraphSRegular.copyWith(
                                color: index == state.currentTab
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
            children: _tabs.map((i) {
              final int index = _tabs.indexOf(i);

              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Tooltip(
                  message: i.title,
                  verticalOffset: 32.0,
                  child: InkWell(
                    onTap: () => _onSelect(
                      context: context,
                      currentTab: state.currentTab,
                      index: index,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: index == state.currentTab
                            ? AppColors.scaffoldSecondary
                            : AppColors.transparent,
                        border: Border.all(
                          color: index == state.currentTab
                              ? AppColors.border
                              : AppColors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SvgPicture.asset(
                        i.icon,
                        width: 20.0,
                        colorFilter: ColorFilter.mode(
                          index == state.currentTab
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          BlendMode.srcIn,
                        ),
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
