import '../medias/media_model.dart';

class ProjectInfoModel {
  const ProjectInfoModel({
    required this.name,
    required this.location,
    required this.description,
    this.media,
  });

  factory ProjectInfoModel.fromJson(Map<Object?, dynamic> json) {
    return ProjectInfoModel(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      media: json['media'] != null
          ? (json['media'] as List).map((e) => MediaModel.fromJson(e)).toList()
          : null,
    );
  }

  final String name;
  final String location;
  final String description;
  final List<MediaModel>? media;
}
