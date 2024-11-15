import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
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
import '../../../widgets/uncategorized/user_status.dart';
import '../../../widgets/views/empty_state_view.dart';
import '../../../widgets/views/table_view.dart';
import 'blocs/team_bloc/team_bloc.dart';

const TranslateLocale _locale = TranslateLocale('team.team');

class TeamPage extends StatelessWidget {
  const TeamPage({
    super.key,
    required this.state,
    required this.navigateToManageUserPage,
  });

  static const routePath = '/team_pages/team';

  final GoRouterState state;
  final void Function([String?]) navigateToManageUserPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeamBloc>(
      create: (_) => TeamBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: DrawerLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<TeamBloc, TeamState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _TeamPageContent(
                  state: state,
                  screenSize: size,
                  navigateToManageUserPage: navigateToManageUserPage,
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
    required this.screenSize,
    required this.navigateToManageUserPage,
  });

  final TeamState state;
  final Size screenSize;
  final void Function([String?]) navigateToManageUserPage;

  void _deleteUser({
    required BuildContext context,
    required String id,
    required String email,
  }) {
    context.read<TeamBloc>().add(
          DeleteUser(
            id: id,
            email: email,
          ),
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
      child: TableView(
        screenSize: screenSize,
        header: SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _locale.tr('team'),
                style: AppTextStyles.head6Medium,
              ),
              if (screenSize.width >= kMobileScreenWidth) ...[
                CustomButton(
                  prefixIcon: AppIcons.add,
                  text: _locale.tr('add_user'),
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageUserPage,
                ),
              ] else ...[
                CustomIconButton(
                  icon: AppIcons.add,
                  addBorder: false,
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageUserPage,
                ),
              ],
            ],
          ),
        ),
        body: EmptyStateView(
          screenSize: screenSize,
          isEmpty: state.users.isEmpty,
          animation: AppAnimations.addUser,
          title: _locale.tr('add_first_user'),
          description: _locale.tr('not_user'),
          buttonText: _locale.tr('add_user'),
          onTap: navigateToManageUserPage,
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
                      title: _locale.tr('customer_name'),
                    ),
                    TableCellItem(
                      flex: 20,
                      title: _locale.tr('email'),
                    ),
                    TableCellItem(
                      flex: 10,
                      alignment: Alignment.center,
                      title: _locale.tr('role'),
                    ),
                    TableCellItem(
                      flex: 15,
                      alignment: Alignment.center,
                      title: _locale.tr('status'),
                    ),
                    TableCellItem(
                      flex: 15,
                      alignment: Alignment.center,
                      title: _locale.tr('date_joined'),
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
                      title: _locale.tr('customer_name'),
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
                  itemCount: state.users.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 60.0,
                      addBorder: i != state.users.length - 1,
                      onTap: () => navigateToManageUserPage(
                        state.users[i].id,
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
                            title: state.users[i].info.name,
                            maxLines: 1,
                          ),
                          TableCellItem(
                            flex: 20,
                            title: state.users[i].credential.email,
                            maxLines: 1,
                          ),
                          TableCellItem(
                            flex: 10,
                            alignment: Alignment.center,
                            title: _locale.tr('worker'),
                            maxLines: 1,
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
                                if (state.users[i].userId == null) ...[
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () => _deleteUser(
                                      context: context,
                                      id: state.users[i].id,
                                      email: state.users[i].credential.email,
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
                                ] else ...[
                                  const SizedBox(width: 8.0),
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
                        ] else ...[
                          TableCellItem(
                            flex: 60,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                            ).copyWith(
                              left: 16.0,
                              right: 4.0,
                            ),
                            title: state.users[i].info.name,
                            maxLines: 1,
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
                                if (state.users[i].userId == null) ...[
                                  const SizedBox(width: 8.0),
                                  GestureDetector(
                                    onTap: () => _deleteUser(
                                      context: context,
                                      id: state.users[i].id,
                                      email: state.users[i].credential.email,
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
                                ] else ...[
                                  const SizedBox(width: 8.0),
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
