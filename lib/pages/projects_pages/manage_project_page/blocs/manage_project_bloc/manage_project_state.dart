part of 'manage_project_bloc.dart';

@immutable
class ManageProjectState {
  const ManageProjectState({
    this.status = BlocStatus.initial,
    this.userData,
    this.project,
    this.projects = const [],
  });

  final BlocStatus status;
  final UserModel? userData;
  final ProjectModel? project;
  final List<ProjectModel> projects;

  ManageProjectState copyWith({
    BlocStatus? status,
    UserModel? userData,
    ProjectModel? project,
    List<ProjectModel>? projects,
  }) {
    return ManageProjectState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      project: project ?? this.project,
      projects: projects ?? this.projects,
    );
  }
}
