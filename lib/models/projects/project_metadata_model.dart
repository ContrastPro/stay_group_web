class ProjectMetadataModel {
  const ProjectMetadataModel({
    required this.createdAt,
  });

  factory ProjectMetadataModel.fromJson(Map<Object?, dynamic> json) {
    return ProjectMetadataModel(
      createdAt: json['createdAt'],
    );
  }

  final String createdAt;
}
