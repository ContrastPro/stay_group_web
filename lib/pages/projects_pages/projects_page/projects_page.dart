import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../repositories/auth_repository.dart';
import '../../../repositories/projects_repository.dart';
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
import 'blocs/projects_bloc/projects_bloc.dart';

const TranslateLocale _locale = TranslateLocale('projects.projects');

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({
    super.key,
    required this.state,
    required this.navigateToManageProjectPage,
  });

  static const routePath = '/projects_pages/projects';

  final GoRouterState state;
  final void Function([String?]) navigateToManageProjectPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsBloc>(
      create: (_) => ProjectsBloc(
        authRepository: context.read<AuthRepository>(),
        usersRepository: context.read<UsersRepository>(),
        projectsRepository: context.read<ProjectsRepository>(),
        storageRepository: context.read<StorageRepository>(),
      )..add(
          const Init(),
        ),
      child: DrawerLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _ProjectsPageContent(
                  state: state,
                  screenSize: size,
                  navigateToManageProjectPage: navigateToManageProjectPage,
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

class _ProjectsPageContent extends StatelessWidget {
  const _ProjectsPageContent({
    required this.state,
    required this.screenSize,
    required this.navigateToManageProjectPage,
  });

  final ProjectsState state;
  final Size screenSize;
  final void Function([String?]) navigateToManageProjectPage;

  void _deleteProject({
    required BuildContext context,
    required String id,
  }) {
    context.read<ProjectsBloc>().add(
          DeleteProject(id: id),
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
                _locale.tr('projects'),
                style: AppTextStyles.head6Medium,
              ),
              if (screenSize.width >= kMobileScreenWidth) ...[
                CustomButton(
                  prefixIcon: AppIcons.add,
                  text: _locale.tr('add_project'),
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageProjectPage,
                ),
              ] else ...[
                CustomIconButton(
                  icon: AppIcons.add,
                  addBorder: false,
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageProjectPage,
                ),
              ],
            ],
          ),
        ),
        body: EmptyStateView(
          screenSize: screenSize,
          isEmpty: state.projects.isEmpty,
          animation: AppAnimations.addProject,
          title: _locale.tr('add_first_project'),
          description: _locale.tr('not_project'),
          buttonText: _locale.tr('add_project'),
          onTap: navigateToManageProjectPage,
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
                      title: _locale.tr('project_name'),
                    ),
                    TableCellItem(
                      flex: 20,
                      title: _locale.tr('location'),
                    ),
                    TableCellItem(
                      flex: 25,
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
                      title: _locale.tr('project_name'),
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
                  itemCount: state.projects.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 60.0,
                      addBorder: i != state.projects.length - 1,
                      onTap: () => navigateToManageProjectPage(
                        state.projects[i].id,
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
                            title: state.projects[i].info.name,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 20,
                            title: state.projects[i].info.location,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 25,
                            title: state.projects[i].info.description,
                            textAlign: TextAlign.start,
                          ),
                          TableCellItem(
                            flex: 15,
                            alignment: Alignment.center,
                            title: utcToLocal(
                              state.projects[i].metadata.createdAt,
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
                                    onTap: () => _deleteProject(
                                      context: context,
                                      id: state.projects[i].id,
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
                            title: state.projects[i].info.name,
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
                                    onTap: () => _deleteProject(
                                      context: context,
                                      id: state.projects[i].id,
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
