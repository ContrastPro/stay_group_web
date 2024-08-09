import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../services/repository_logger_service.dart';

class StorageRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'StorageRepository',
  );

  static final FirebaseStorage _api = FirebaseStorage.instance;

  Reference _getRef({
    required bool isThumbnail,
    required String spaceId,
    required String id,
  }) {
    if (isThumbnail) {
      return _api.ref('$spaceId/thumbnails/$id');
    }

    return _api.ref('$spaceId/media/$id');
  }

  Future<String> uploadMedia({
    required bool isThumbnail,
    required String spaceId,
    required String id,
    required Uint8List mediaData,
    required String format,
  }) async {
    final Reference reference = _getRef(
      isThumbnail: isThumbnail,
      spaceId: spaceId,
      id: id,
    );

    await reference.putData(
      mediaData,
      SettableMetadata(
        contentType: 'image/$format',
      ),
    );

    _logger.log('Successful', name: 'uploadMedia');

    return await reference.getDownloadURL();
  }

  Future<void> deleteMedia({
    required bool isThumbnail,
    required String spaceId,
    required String id,
  }) async {
    final Reference reference = _getRef(
      isThumbnail: isThumbnail,
      spaceId: spaceId,
      id: id,
    );

    await reference.delete();

    _logger.log('Successful', name: 'deleteMedia');
  }
}
