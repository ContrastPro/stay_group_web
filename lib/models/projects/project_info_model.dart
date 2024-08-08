class ProjectInfoModel {
  const ProjectInfoModel({
    required this.name,
    required this.description,
  });

  factory ProjectInfoModel.fromJson(Map<Object?, dynamic> json) {
    return ProjectInfoModel(
      name: json['name'],
      description: json['description'],
    );
  }

  final String name;
  final String description;
}
