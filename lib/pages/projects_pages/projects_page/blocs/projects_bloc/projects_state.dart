part of 'projects_bloc.dart';

@immutable
class ProjectsState {
  const ProjectsState({
    this.status = BlocStatus.initial,
    this.userData,
    this.projects = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final List<ProjectModel> projects;

  ProjectsState copyWith({
    BlocStatus? status,
    UserModel? userData,
    List<ProjectModel>? projects,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      projects: projects ?? this.projects,
    );
  }
}
