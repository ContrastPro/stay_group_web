part of 'projects_bloc.dart';

@immutable
class ProjectsState {
  const ProjectsState({
    this.status = BlocStatus.initial,
    this.projects = const [],
  });

  final BlocStatus status;
  final List<ProjectModel> projects;

  ProjectsState copyWith({
    BlocStatus? status,
    List<ProjectModel>? projects,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
    );
  }
}
