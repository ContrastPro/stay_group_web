import 'project_model.dart';

class ProjectResponseModel {
  const ProjectResponseModel({
    required this.projects,
  });

  factory ProjectResponseModel.fromJson(Map<Object?, dynamic> json) {
    return ProjectResponseModel(
      projects: json.values.map((e) => ProjectModel.fromJson(e)).toList(),
    );
  }

  final List<ProjectModel> projects;
}
