import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../models/uncategorized/media_response_model.dart';

class MediaService {
  const MediaService._();

  static const MediaService instance = MediaService._();

  static final ImagePicker _imagePicker = ImagePicker();

  Future<MediaResponseModel?> pickGallery() async {
    final XFile? pickedImage = await _pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final Uint8List data = await pickedImage.readAsBytes();

      final Uint8List? thumbnail = await compressQuality(
        index: 4,
        data: data,
      );

      final String format = pickedImage.name.split('.').last;

      return MediaResponseModel(
        data: data,
        thumbnail: thumbnail,
        path: pickedImage.path,
        format: format,
        name: pickedImage.name,
      );
    }

    return null;
  }

  Future<XFile?> _pickImage({
    required ImageSource source,
  }) async {
    final XFile? image = await _imagePicker.pickImage(
      source: source,
      requestFullMetadata: false,
    );

    return image;
  }

  Future<Uint8List?> compressQuality({
    required Uint8List data,
    int index = 2,
    int quality = 80,
  }) async {
    try {
      final ui.Image image = await decodeImageFromList(data);

      final Uint8List thumbnail = await FlutterImageCompress.compressWithList(
        data,
        minWidth: image.width ~/ index,
        minHeight: image.height ~/ index,
        quality: quality,
      );

      return thumbnail;
    } catch (e) {
      return null;
    }
  }
}
