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
import 'blocs/calculations_bloc/calculations_bloc.dart';

const TranslateLocale _system = TranslateLocale('system');

const TranslateLocale _locale = TranslateLocale('calculations.calculations');

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({
    super.key,
    required this.state,
    required this.navigateToManageCalculationPage,
  });

  static const routePath = '/calculations_pages/calculations';

  final GoRouterState state;
  final void Function([String?]) navigateToManageCalculationPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculationsBloc>(
      create: (_) => CalculationsBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
        calculationsRepository: context.read<CalculationsRepository>(),
      )..add(
          const Init(),
        ),
      child: DrawerLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<CalculationsBloc, CalculationsState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _CalculationsPageContent(
                  state: state,
                  screenSize: size,
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
    required this.screenSize,
    required this.navigateToManageCalculationPage,
  });

  final CalculationsState state;
  final Size screenSize;
  final void Function([String?]) navigateToManageCalculationPage;

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

      return _system.tr(period.name);
    }

    return '—';
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
                _locale.tr('calculations'),
                style: AppTextStyles.head6Medium,
              ),
              if (screenSize.width >= kMobileScreenWidth) ...[
                CustomButton(
                  prefixIcon: AppIcons.add,
                  text: _locale.tr('add_calculation'),
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCalculationPage,
                ),
              ] else ...[
                CustomIconButton(
                  icon: AppIcons.add,
                  addBorder: false,
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCalculationPage,
                ),
              ],
            ],
          ),
        ),
        body: EmptyStateView(
          screenSize: screenSize,
          isEmpty: state.calculations.isEmpty,
          animation: AppAnimations.addCalculation,
          title: _locale.tr('add_first_calculation'),
          description: _locale.tr('not_calculation'),
          buttonText: _locale.tr('add_calculation'),
          onTap: navigateToManageCalculationPage,
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
                      title: _locale.tr('calculation_name'),
                    ),
                    TableCellItem(
                      flex: 12,
                      title: _locale.tr('unit_price'),
                    ),
                    TableCellItem(
                      flex: 21,
                      title: _locale.tr('installment_terms'),
                    ),
                    TableCellItem(
                      flex: 12,
                      title: _locale.tr('installment_plan'),
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
                      title: _locale.tr('calculation_name'),
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
                  itemCount: state.calculations.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 60.0,
                      addBorder: i != state.calculations.length - 1,
                      onTap: () => navigateToManageCalculationPage(
                        state.calculations[i].id,
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
                                    onTap: () => _deleteCalculation(
                                      context: context,
                                      id: state.calculations[i].id,
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
                            title: state.calculations[i].info.name,
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
                                    onTap: () => _deleteCalculation(
                                      context: context,
                                      id: state.calculations[i].id,
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
