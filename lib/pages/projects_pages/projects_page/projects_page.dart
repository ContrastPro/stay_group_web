import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../models/projects/project_model.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/projects_repository.dart';
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
import 'blocs/projects_bloc/projects_bloc.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({
    super.key,
    required this.state,
    required this.navigateToManageProjectPage,
  });

  static const routePath = '/projects_pages/projects';

  final GoRouterState state;
  final void Function([ProjectModel?]) navigateToManageProjectPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsBloc>(
      create: (_) => ProjectsBloc(
        authRepository: context.read<AuthRepository>(),
        projectsRepository: context.read<ProjectsRepository>(),
        usersRepository: context.read<UsersRepository>(),
      )..add(
          const GetProjects(),
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
  final void Function([ProjectModel?]) navigateToManageProjectPage;

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
      child: EmptyStateView(
        isEmpty: state.projects.isEmpty,
        animation: AppAnimations.addProject,
        title: 'Add first project',
        description:
            "You don't added your first project yet - let's get started!",
        buttonWidth: 160.0,
        buttonText: 'Add project',
        onTap: navigateToManageProjectPage,
        content: TablesLayout(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 160.0,
                child: CustomButton(
                  prefixIcon: AppIcons.add,
                  text: 'Add project',
                  backgroundColor: AppColors.info,
                  onTap: navigateToManageProjectPage,
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
                    title: 'Project Name',
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
                          title: state.projects[i].info.name,
                          maxLines: 1,
                        ),
                        TableCellItem(
                          flex: 15,
                          alignment: Alignment.center,
                          title: utcToLocal(
                            state.projects[i].metadata.createdAt,
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
                                onTap: () => navigateToManageProjectPage(
                                  state.projects[i],
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
                                onTap: () => _deleteProject(
                                  context: context,
                                  id: state.projects[i].id,
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
