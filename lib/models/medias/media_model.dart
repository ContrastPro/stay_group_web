class MediaModel {
  const MediaModel({
    required this.id,
    required this.data,
    required this.thumbnail,
    required this.format,
    required this.name,
  });

  factory MediaModel.fromJson(Map<Object?, dynamic> json) {
    return MediaModel(
      id: json['id'],
      data: json['data'],
      thumbnail: json['thumbnail'],
      format: json['format'],
      name: json['name'],
    );
  }

  final String id;
  final String data;
  final String thumbnail;
  final String format;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data,
        'thumbnail': thumbnail,
        'format': format,
        'name': name,
      };
}
