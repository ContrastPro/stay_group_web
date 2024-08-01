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

  void _deleteUser({
    required BuildContext context,
    required String id,
  }) {
    context.read<TeamBloc>().add(
          DeleteUser(id: id),
        );
  }

  void _switchUserArchive({
    required BuildContext context,
    required String id,
    required bool archived,
  }) {
    context.read<TeamBloc>().add(
          SwitchUserArchive(
            id: id,
            archived: !archived,
          ),
        );
  }

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
              cells: [
                TableCellItem(
                  flex: 20,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ).copyWith(
                    left: 16.0,
                    right: 4.0,
                  ),
                  title: 'Customer Full Name',
                ),
                const TableCellItem(
                  flex: 25,
                  title: 'Email',
                ),
                const TableCellItem(
                  flex: 10,
                  alignment: Alignment.center,
                  title: 'Role',
                ),
                const TableCellItem(
                  flex: 15,
                  alignment: Alignment.center,
                  title: 'Status',
                ),
                const TableCellItem(
                  flex: 15,
                  alignment: Alignment.center,
                  title: 'Date Joined',
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
                itemCount: state.users.length,
                itemBuilder: (_, int i) {
                  return TableItem(
                    height: 68.0,
                    cells: [
                      TableCellItem(
                        flex: 20,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ).copyWith(
                          left: 16.0,
                          right: 4.0,
                        ),
                        title: state.users[i].info.name,
                      ),
                      TableCellItem(
                        flex: 25,
                        title: state.users[i].credential.email,
                      ),
                      const TableCellItem(
                        flex: 10,
                        alignment: Alignment.center,
                        title: 'Worker',
                      ),
                      TableCellItem(
                        flex: 15,
                        alignment: Alignment.center,
                        child: UserStatus(
                          archived: state.users[i].archived,
                        ),
                      ),
                      TableCellItem(
                        flex: 15,
                        alignment: Alignment.center,
                        title: utcToLocal(
                          state.users[i].metadata.createdAt,
                          format: DateFormat(
                            'dd/MM/yy',
                          ),
                        ),
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
                            const SizedBox(width: 12.0),
                            if (state.users[i].userId == null) ...[
                              GestureDetector(
                                onTap: () => _deleteUser(
                                  context: context,
                                  id: state.users[i].id,
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
                            ] else ...[
                              GestureDetector(
                                onTap: () => _switchUserArchive(
                                  context: context,
                                  id: state.users[i].id,
                                  archived: state.users[i].archived,
                                ),
                                behavior: HitTestBehavior.opaque,
                                child: SvgPicture.asset(
                                  state.users[i].archived
                                      ? AppIcons.visibilityOn
                                      : AppIcons.visibilityOff,
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
    );
  }
}
