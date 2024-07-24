import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/users_repository.dart';
import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/layouts/tables_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/uncategorized/table_item.dart';
import '../../../widgets/uncategorized/user_status.dart';
import 'blocs/team_bloc/team_bloc.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({
    super.key,
    required this.state,
    required this.navigateToManageUserPage,
  });

  static const routePath = '/team_pages/team';

  final GoRouterState state;
  final void Function() navigateToManageUserPage;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamBloc>(
      create: (_) => TeamBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const GetUsers(),
        ),
      child: FlexibleLayout(
        state: widget.state,
        builder: (Size size) {
          return BlocBuilder<TeamBloc, TeamState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _TeamPageContent(
                  state: state,
                  navigateToManageUserPage: widget.navigateToManageUserPage,
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

class _TeamPageContent extends StatelessWidget {
  const _TeamPageContent({
    required this.state,
    required this.navigateToManageUserPage,
  });

  final TeamState state;
  final void Function() navigateToManageUserPage;

  @override
  Widget build(BuildContext context) {
    return FadeInAnimation(
      duration: kFadeInDuration,
      child: TablesLayout(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 140.0,
              child: CustomButton(
                prefixIcon: AppIcons.add,
                text: 'Add user',
                backgroundColor: AppColors.info,
                onTap: navigateToManageUserPage,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            TableItem(
              backgroundColor: AppColors.border,
              borderRadius: BorderRadius.circular(8.0),
              cells: const [
                TableCellItem(
                  flex: 20,
                  title: 'Customer Full Name',
                ),
                TableCellItem(
                  flex: 30,
                  title: 'Email',
                ),
                TableCellItem(
                  flex: 15,
                  title: 'Role',
                ),
                TableCellItem(
                  flex: 15,
                  title: 'Status',
                ),
                TableCellItem(
                  flex: 10,
                  alignment: Alignment.center,
                  title: 'Date Joined',
                ),
                TableCellItem(
                  flex: 10,
                  alignment: Alignment.center,
                  title: 'Actions',
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (_, int i) {
                  return TableItem(
                    height: 68.0,
                    cells: [
                      TableCellItem(
                        flex: 20,
                        title: state.users[i].info.name,
                      ),
                      TableCellItem(
                        flex: 30,
                        title: state.users[i].info.email,
                      ),
                      const TableCellItem(
                        flex: 15,
                        title: 'Worker',
                      ),
                      TableCellItem(
                        flex: 15,
                        child: UserStatus(
                          archived: state.users[i].archived,
                        ),
                      ),
                      TableCellItem(
                        flex: 10,
                        alignment: Alignment.center,
                        title: utcToLocal(
                          state.users[i].metadata.createdAt,
                          format: DateFormat(
                            'dd/MM/yy',
                          ),
                        ),
                      ),
                      TableCellItem(
                        flex: 10,
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
                            const SizedBox(width: 12.0),
                            SvgPicture.asset(
                              AppIcons.delete,
                              width: 22.0,
                              colorFilter: const ColorFilter.mode(
                                AppColors.iconPrimary,
                                BlendMode.srcIn,
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
    );
  }
}
