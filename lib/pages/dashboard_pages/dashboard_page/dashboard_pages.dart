import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/companies/company_model.dart';
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
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/layouts/tables_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';
import '../../../widgets/uncategorized/table_item.dart';
import 'blocs/dashboard_bloc/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.state,
    required this.navigateToManageCompanyPage,
  });

  static const routePath = '/dashboard_pages/dashboard';

  final GoRouterState state;
  final void Function([CompanyModel?]) navigateToManageCompanyPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (_) => DashboardBloc(
        authRepository: context.read<AuthRepository>(),
        companiesRepository: context.read<CompaniesRepository>(),
        storageRepository: context.read<StorageRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const GetCompanies(),
        ),
      child: FlexibleLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _DashboardPageContent(
                  state: state,
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
    required this.navigateToManageCompanyPage,
  });

  final DashboardState state;
  final void Function([CompanyModel?]) navigateToManageCompanyPage;

  static const double _buttonWidth = 180.0;

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
      child: TablesLayout(
        header: SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dashboard',
                style: AppTextStyles.head6Medium,
              ),
              SizedBox(
                width: _buttonWidth,
                child: CustomButton(
                  prefixIcon: AppIcons.add,
                  text: 'Add company',
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCompanyPage,
                ),
              ),
            ],
          ),
        ),
        body: EmptyStateView(
          isEmpty: state.companies.isEmpty,
          animation: AppAnimations.addCompany,
          title: 'Add first company',
          description:
              "You don't added your first company yet.\nLet's get started!",
          buttonWidth: _buttonWidth,
          buttonText: 'Add company',
          onTap: navigateToManageCompanyPage,
          content: Column(
            children: [
              TableItem(
                backgroundColor: AppColors.border,
                borderRadius: BorderRadius.circular(8.0),
                cells: [
                  TableCellItem(
                    flex: 70,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ).copyWith(
                      left: 16.0,
                      right: 4.0,
                    ),
                    title: 'Company Name',
                  ),
                  const TableCellItem(
                    flex: 15,
                    alignment: Alignment.center,
                    title: 'Date Creation',
                  ),
                  const TableCellItem(
                    flex: 15,
                    alignment: Alignment.center,
                    title: 'Actions',
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.companies.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 68.0,
                      cells: [
                        TableCellItem(
                          flex: 70,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ).copyWith(
                            left: 16.0,
                            right: 4.0,
                          ),
                          title: state.companies[i].info.name,
                          maxLines: 1,
                        ),
                        TableCellItem(
                          flex: 15,
                          alignment: Alignment.center,
                          title: utcToLocal(
                            state.companies[i].metadata.createdAt,
                            format: DateFormat('dd/MM/yy'),
                          ),
                          maxLines: 1,
                        ),
                        TableCellItem(
                          flex: 15,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => navigateToManageCompanyPage(
                                  state.companies[i],
                                ),
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  AppIcons.edit,
                                  width: 22.0,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.iconPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              GestureDetector(
                                onTap: () => _deleteCompany(
                                  context: context,
                                  id: state.companies[i].id,
                                ),
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  AppIcons.delete,
                                  width: 22.0,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.iconPrimary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
