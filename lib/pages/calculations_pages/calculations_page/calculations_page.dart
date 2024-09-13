import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/calculations/calculation_info_model.dart';
import '../../../models/calculations/calculation_period_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/calculations_repository.dart';
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
import '../../../widgets/tables/table_cell_item.dart';
import '../../../widgets/tables/table_item.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';
import '../manage_calculation_page/manage_calculation_page.dart';
import 'blocs/calculations_bloc/calculations_bloc.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({
    super.key,
    required this.state,
    required this.navigateToManageCalculationPage,
  });

  static const routePath = '/calculations_pages/calculations';

  final GoRouterState state;
  final void Function(ManageCalculationPageArguments)
      navigateToManageCalculationPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculationsBloc>(
      create: (_) => CalculationsBloc(
        authRepository: context.read<AuthRepository>(),
        calculationsRepository: context.read<CalculationsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: FlexibleLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<CalculationsBloc, CalculationsState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _CalculationsPageContent(
                  state: state,
                  navigateToManageCalculationPage:
                      navigateToManageCalculationPage,
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

class _CalculationsPageContent extends StatelessWidget {
  const _CalculationsPageContent({
    required this.state,
    required this.navigateToManageCalculationPage,
  });

  final CalculationsState state;
  final void Function(ManageCalculationPageArguments)
      navigateToManageCalculationPage;

  static const double _buttonWidth = 190.0;

  void _deleteCalculation({
    required BuildContext context,
    required String id,
  }) {
    context.read<CalculationsBloc>().add(
          DeleteCalculation(id: id),
        );
  }

  String _getCalculationPrice(CalculationInfoModel info) {
    if (info.price != null) {
      return '${info.currency}${info.price}';
    }

    return '${info.currency}0';
  }

  String _getCalculationTerms(CalculationInfoModel info) {
    if (info.startInstallments != null && info.endInstallments != null) {
      final DateTime startInstallments = DateTime.parse(
        info.startInstallments!,
      );

      final DateTime endInstallments = DateTime.parse(
        info.endInstallments!,
      );

      final DateFormat dateFormat = DateFormat('MMMM, yy');
      final String start = dateFormat.format(startInstallments);
      final String end = dateFormat.format(endInstallments);

      return '$start - $end';
    }

    return '—';
  }

  String _getCalculationPlan(CalculationInfoModel info) {
    if (info.period != null) {
      final CalculationPeriodModel period = kPeriods.firstWhere(
        (e) => e.month == info.period,
      );

      return period.name;
    }

    return '—';
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
                'Calculations',
                style: AppTextStyles.head6Medium,
              ),
              SizedBox(
                width: _buttonWidth,
                child: CustomButton(
                  prefixIcon: AppIcons.add,
                  text: 'Add calculation',
                  backgroundColor: AppColors.info,
                  onTap: () => navigateToManageCalculationPage(
                    ManageCalculationPageArguments(
                      count: state.calculations.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: EmptyStateView(
          isEmpty: state.calculations.isEmpty,
          animation: AppAnimations.addCalculation,
          title: 'Add first calculation',
          description:
              "You don't added your first calculation yet.\nLet's get started!",
          buttonWidth: _buttonWidth,
          buttonText: 'Add calculation',
          onTap: () => navigateToManageCalculationPage(
            ManageCalculationPageArguments(
              count: state.calculations.length,
            ),
          ),
          content: Column(
            children: [
              TableItem(
                backgroundColor: AppColors.border,
                borderRadius: BorderRadius.circular(8.0),
                cells: [
                  TableCellItem(
                    flex: 25,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ).copyWith(
                      left: 16.0,
                      right: 4.0,
                    ),
                    title: 'Calculation Name',
                  ),
                  const TableCellItem(
                    flex: 12,
                    title: 'Unit price',
                  ),
                  const TableCellItem(
                    flex: 21,
                    title: 'Installment terms',
                  ),
                  const TableCellItem(
                    flex: 12,
                    title: 'Installment plan',
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
                  itemCount: state.calculations.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      addBorder: i != state.calculations.length - 1,
                      height: 68.0,
                      cells: [
                        TableCellItem(
                          flex: 25,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ).copyWith(
                            left: 16.0,
                            right: 4.0,
                          ),
                          title: state.calculations[i].info.name,
                          textAlign: TextAlign.start,
                        ),
                        TableCellItem(
                          flex: 12,
                          title: _getCalculationPrice(
                            state.calculations[i].info,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        TableCellItem(
                          flex: 21,
                          title: _getCalculationTerms(
                            state.calculations[i].info,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        TableCellItem(
                          flex: 12,
                          title: _getCalculationPlan(
                            state.calculations[i].info,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        TableCellItem(
                          flex: 15,
                          alignment: Alignment.center,
                          title: utcToLocal(
                            state.calculations[i].metadata.createdAt,
                            format: 'dd/MM/yy',
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
                                onTap: () => navigateToManageCalculationPage(
                                  ManageCalculationPageArguments(
                                    count: state.calculations.length,
                                    calculation: state.calculations[i],
                                  ),
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
                              if (state.userData!.spaceId == null) ...[
                                const SizedBox(width: 12.0),
                                GestureDetector(
                                  onTap: () => _deleteCalculation(
                                    context: context,
                                    id: state.calculations[i].id,
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
