import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/companies_repository.dart';
import '../../../repositories/storage_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_animations.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../utils/translate_locale.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/buttons/custom_icon_button.dart';
import '../../../widgets/layouts/drawer_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/tables/table_cell_item.dart';
import '../../../widgets/tables/table_item.dart';
import '../../../widgets/views/empty_state_view.dart';
import '../../../widgets/views/table_view.dart';
import 'blocs/dashboard_bloc/dashboard_bloc.dart';

const TranslateLocale _locale = TranslateLocale('dashboard.dashboard');

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.state,
    required this.navigateToManageCompanyPage,
  });

  static const routePath = '/dashboard_pages/dashboard';

  final GoRouterState state;
  final void Function([String?]) navigateToManageCompanyPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (_) => DashboardBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
        companiesRepository: context.read<CompaniesRepository>(),
        storageRepository: context.read<StorageRepository>(),
      )..add(
          const Init(),
        ),
      child: DrawerLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _DashboardPageContent(
                  state: state,
                  screenSize: size,
                  navigateToManageCompanyPage: navigateToManageCompanyPage,
                );
              }

              return const Center(
                child: CustomLoader(),
              );
            },
          );
        },
      ),
    );
  }
}

class _DashboardPageContent extends StatelessWidget {
  const _DashboardPageContent({
    required this.state,
    required this.screenSize,
    required this.navigateToManageCompanyPage,
  });

  final DashboardState state;
  final Size screenSize;
  final void Function([String?]) navigateToManageCompanyPage;

  void _deleteCompany({
    required BuildContext context,
    required String id,
  }) {
    context.read<DashboardBloc>().add(
          DeleteCompany(id: id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: TableView(
        screenSize: screenSize,
        header: SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _locale.tr('companies'),
                style: AppTextStyles.head6Medium,
              ),
              if (screenSize.width >= kMobileScreenWidth) ...[
                CustomButton(
                  prefixIcon: AppIcons.add,
                  text: _locale.tr('add_company'),
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCompanyPage,
                ),
              ] else ...[
                CustomIconButton(
                  icon: AppIcons.add,
                  addBorder: false,
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCompanyPage,
                ),
              ],
            ],
          ),
        ),
        body: EmptyStateView(
          screenSize: screenSize,
          isEmpty: state.companies.isEmpty,
          animation: AppAnimations.addCompany,
          title: _locale.tr('add_first_company'),
          description: _locale.tr('not_company'),
          buttonText: _locale.tr('add_company'),
          onTap: navigateToManageCompanyPage,
          content: Column(
            children: [
              TableItem(
                backgroundColor: AppColors.border,
                borderRadius: BorderRadius.circular(8.0),
                cells: [
                  if (screenSize.width >= kMobileScreenWidth) ...[
                    TableCellItem(
                      flex: 25,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ).copyWith(
                        left: 16.0,
                        right: 4.0,
                      ),
                      title: _locale.tr('company_name'),
                    ),
                    TableCellItem(
                      flex: 45,
                      title: _locale.tr('description'),
                    ),
                    TableCellItem(
                      flex: 15,
                      alignment: Alignment.center,
                      title: _locale.tr('date_creation'),
                    ),
                    TableCellItem(
                      flex: 15,
                      alignment: Alignment.center,
                      title: _locale.tr('actions'),
                    ),
                  ] else ...[
                    TableCellItem(
                      flex: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ).copyWith(
                        left: 16.0,
                        right: 4.0,
                      ),
                      title: _locale.tr('company_name'),
                    ),
                    TableCellItem(
                      flex: 40,
                      alignment: Alignment.center,
                      title: _locale.tr('actions'),
                    ),
                  ],
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.companies.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 60.0,
                      addBorder: i != state.companies.length - 1,
                      onTap: () => navigateToManageCompanyPage(
                        state.companies[i].id,
                      ),
                      cells: [
                        if (screenSize.width >= kMobileScreenWidth) ...[
                          TableCellItem(
                            flex: 25,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ).copyWith(
                              left: 16.0,
                              right: 4.0,
                            ),
                            title: state.companies[i].info.name,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 45,
                            title: state.companies[i].info.description,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 15,
                            alignment: Alignment.center,
                            title: utcToLocal(
                              state.companies[i].metadata.createdAt,
                              format: kDatePattern,
                            ),
                            maxLines: 1,
                          ),
                          TableCellItem(
                            flex: 15,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.edit,
                                  width: 22.0,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.iconPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (state.userData!.spaceId == null) ...[
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () => _deleteCompany(
                                      context: context,
                                      id: state.companies[i].id,
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: SvgPicture.asset(
                                      AppIcons.delete,
                                      width: 24.0,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.iconPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ] else ...[
                          TableCellItem(
                            flex: 60,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ).copyWith(
                              left: 16.0,
                              right: 4.0,
                            ),
                            title: state.companies[i].info.name,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 40,
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AppIcons.edit,
                                  width: 22.0,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.iconPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (state.userData!.spaceId == null) ...[
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () => _deleteCompany(
                                      context: context,
                                      id: state.companies[i].id,
                                    ),
                                    behavior: HitTestBehavior.opaque,
                                    child: SvgPicture.asset(
                                      AppIcons.delete,
                                      width: 24.0,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.iconPrimary,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
