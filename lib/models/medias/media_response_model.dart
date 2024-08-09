import 'dart:typed_data';

class MediaResponseModel {
  const MediaResponseModel({
    required this.id,
    this.data,
    this.dataUrl,
    this.thumbnail,
    this.thumbnailUrl,
    required this.format,
    required this.name,
  });

  final String id;
  final Uint8List? data;
  final String? dataUrl;
  final Uint8List? thumbnail;
  final String? thumbnailUrl;
  final String format;
  final String name;
}
