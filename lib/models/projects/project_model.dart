import 'project_info_model.dart';
import 'project_metadata_model.dart';

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.info,
    required this.metadata,
  });

  factory ProjectModel.fromJson(Map<Object?, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      info: ProjectInfoModel.fromJson(json['info']),
      metadata: ProjectMetadataModel.fromJson(json['metadata']),
    );
  }

  final String id;
  final ProjectInfoModel info;
  final ProjectMetadataModel metadata;
}
