import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/calculations/calculation_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/calculations_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_animations.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/layouts/tables_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';
import '../../../widgets/uncategorized/table_item.dart';
import 'blocs/calculations_bloc/calculations_bloc.dart';

class CalculationsPage extends StatelessWidget {
  const CalculationsPage({
    super.key,
    required this.state,
    required this.navigateToManageCalculationPage,
  });

  static const routePath = '/calculations_pages/calculations';

  final GoRouterState state;
  final void Function([CalculationModel?]) navigateToManageCalculationPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CalculationsBloc>(
      create: (_) => CalculationsBloc(
        authRepository: context.read<AuthRepository>(),
        calculationsRepository: context.read<CalculationsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const GetCalculations(),
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
  final void Function([CalculationModel?]) navigateToManageCalculationPage;

  void _deleteCalculation({
    required BuildContext context,
    required String id,
  }) {
    context.read<CalculationsBloc>().add(
          DeleteCalculation(id: id),
        );
  }

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      child: EmptyStateView(
        isEmpty: state.calculations.isEmpty,
        animation: AppAnimations.addCalculation,
        title: 'Add first calculation',
        description:
            "You don't added your first calculation yet - let's get started!",
        buttonWidth: 190.0,
        buttonText: 'Add calculation',
        onTap: navigateToManageCalculationPage,
        content: TablesLayout(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 190.0,
                child: CustomButton(
                  prefixIcon: AppIcons.add,
                  text: 'Add calculation',
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageCalculationPage,
                ),
              ),
            ],
          ),
          body: Column(
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
                    title: 'Calculation Name',
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
                          title: state.calculations[i].info.name,
                          maxLines: 1,
                        ),
                        TableCellItem(
                          flex: 15,
                          alignment: Alignment.center,
                          title: utcToLocal(
                            state.calculations[i].metadata.createdAt,
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
                                onTap: () => navigateToManageCalculationPage(
                                  state.calculations[i],
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
