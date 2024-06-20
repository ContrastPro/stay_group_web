import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/navigation_bloc/navigation_bloc.dart';
import '../../models/uncategorized/custom_bottom_navigation_bar_item_model.dart';
import '../../pages/account_settings_pages/account_settings_page/account_settings_page.dart';
import '../../pages/building_companies_pages/building_companies_page/building_companies_pages.dart';
import '../../pages/projects_pages/projects_page/projects_page.dart';
import '../../pages/team_pages/team_page/team_page.dart';
import '../../resources/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  static const List<String> _pages = [
    BuildingCompaniesPage.routeName,
    ProjectsPage.routeName,
    TeamPage.routeName,
    AccountSettingsPage.routeName,
  ];

  final List<CustomBottomNavigationBarItemModel> _tabs = const [
    CustomBottomNavigationBarItemModel(
      icon: Icons.home_rounded,
      title: 'Home',
    ),
    CustomBottomNavigationBarItemModel(
      icon: Icons.add_business_rounded,
      title: 'Projects',
    ),
    CustomBottomNavigationBarItemModel(
      icon: Icons.supervised_user_circle_rounded,
      title: 'Team',
    ),
    CustomBottomNavigationBarItemModel(
      icon: Icons.settings_rounded,
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
        return SizedBox(
          width: 216.0,
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
                          Icon(
                            i.icon,
                            size: 20.0,
                            color: index == state.currentTab
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            i.title,
                            style: TextStyle(
                              color: index == state.currentTab
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                              fontSize: 11.0,
                              height: 1.18,
                            ),
                          )
                        ],
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
