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
import '../../../widgets/animations/fade_in_animation.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/layouts/flexible_layout.dart';
import '../../../widgets/layouts/tables_layout.dart';
import '../../../widgets/loaders/custom_loader.dart';
import '../../../widgets/tables/table_cell_item.dart';
import '../../../widgets/tables/table_item.dart';
import '../../../widgets/uncategorized/empty_state_view.dart';
import 'blocs/projects_bloc/projects_bloc.dart';

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
        projectsRepository: context.read<ProjectsRepository>(),
        storageRepository: context.read<StorageRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const Init(),
        ),
      child: FlexibleLayout(
        state: state,
        builder: (Size size) {
          return BlocBuilder<ProjectsBloc, ProjectsState>(
            builder: (context, state) {
              if (state.status == BlocStatus.success) {
                return _ProjectsPageContent(
                  state: state,
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
    required this.navigateToManageProjectPage,
  });

  final ProjectsState state;
  final void Function([String?]) navigateToManageProjectPage;

  static const double _buttonWidth = 160.0;

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
      child: TablesLayout(
        header: SizedBox(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Projects',
                style: AppTextStyles.head6Medium,
              ),
              SizedBox(
                width: _buttonWidth,
                child: CustomButton(
                  prefixIcon: AppIcons.add,
                  text: 'Add project',
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageProjectPage,
                ),
              ),
            ],
          ),
        ),
        body: EmptyStateView(
          isEmpty: state.projects.isEmpty,
          animation: AppAnimations.addProject,
          title: 'Add first project',
          description:
              "You don't added your first project yet.\nLet's get started!",
          buttonWidth: _buttonWidth,
          buttonText: 'Add project',
          onTap: navigateToManageProjectPage,
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
                    title: 'Project Name',
                  ),
                  const TableCellItem(
                    flex: 20,
                    title: 'Location',
                  ),
                  const TableCellItem(
                    flex: 25,
                    title: 'Description',
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
                  itemCount: state.projects.length,
                  itemBuilder: (_, int i) {
                    return TableItem(
                      height: 60.0,
                      addBorder: i != state.projects.length - 1,
                      onTap: () => navigateToManageProjectPage(
                        state.projects[i].id,
                      ),
                      cells: [
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
                              const SizedBox(width: 12.0),
                              SvgPicture.asset(
                                AppIcons.edit,
                                width: 22.0,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.iconPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              if (state.userData!.spaceId == null) ...[
                                GestureDetector(
                                  onTap: () => _deleteProject(
                                    context: context,
                                    id: state.projects[i].id,
                                  ),
                                  behavior: HitTestBehavior.opaque,
                                  child: SizedBox(
                                    width: 44.0,
                                    height: 44.0,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
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
                                ),
                              ] else ...[
                                const SizedBox(width: 12.0),
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
