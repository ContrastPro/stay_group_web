import '../medias/media_model.dart';

class CompanyInfoModel {
  const CompanyInfoModel({
    required this.name,
    required this.description,
    this.media,
  });

  factory CompanyInfoModel.fromJson(Map<Object?, dynamic> json) {
    return CompanyInfoModel(
      name: json['name'],
      description: json['description'],
      media: json['media'] != null
          ? (json['media'] as List).map((e) => MediaModel.fromJson(e)).toList()
          : null,
    );
  }

  final String name;
  final String description;
  final List<MediaModel>? media;
}
