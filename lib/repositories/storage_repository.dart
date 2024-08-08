import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../services/repository_logger_service.dart';

class StorageRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'StorageRepository',
  );

  static final FirebaseStorage _api = FirebaseStorage.instance;

  Reference _getRef({
    required String spaceId,
    required String id,
  }) {
    return _api.ref('$spaceId/$id');
  }

  Future<String?> saveMedia({
    required String spaceId,
    required String id,
    required Uint8List mediaData,
  }) async {
    try {
      final Reference reference = _getRef(
        spaceId: spaceId,
        id: id,
      );

      await reference.putData(mediaData);

      _logger.log('Successful', name: 'saveMedia');

      return await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      _logger.log(e.code, name: 'saveMedia');
      return null;
    }
  }

  Future<void> deleteMedia({
    required String spaceId,
    required String id,
  }) async {
    final Reference reference = _getRef(
      spaceId: spaceId,
      id: id,
    );

    await reference.delete();

    _logger.log('Successful', name: 'deleteMedia');
  }
}
