import 'dart:typed_data';

class MediaResponseModel {
  const MediaResponseModel({
    required this.data,
    this.thumbnail,
    this.path,
    required this.format,
    required this.name,
  });

  final Uint8List data;
  final Uint8List? thumbnail;
  final String? path;
  final String format;
  final String name;
}
