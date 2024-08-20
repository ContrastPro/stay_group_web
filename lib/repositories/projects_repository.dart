import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/medias/media_model.dart';
import '../models/projects/project_response_model.dart';
import '../services/repository_logger_service.dart';
import '../utils/helpers.dart';

class ProjectsRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'ProjectsRepository',
  );

  static final FirebaseDatabase _api = FirebaseDatabase.instance;

  DatabaseReference _getRef(
    String spaceId, {
    String? id,
  }) {
    if (id == null) {
      return _api.ref('projects/$spaceId');
    }

    return _api.ref('projects/$spaceId/$id');
  }

  Future<void> createProject({
    required String spaceId,
    required String id,
    List<MediaModel>? media,
    required String name,
    required String location,
    required String description,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.set({
      'id': id,
      'info': {
        'media': media?.map((e) => e.toJson()).toList(),
        'name': name,
        'location': location,
        'description': description,
      },
      'metadata': {
        'createdAt': localToUtc(currentTime()),
      },
    });

    _logger.log('Successful', name: 'createProject');
  }

  Future<void> updateProjectInfo({
    required String spaceId,
    required String id,
    List<MediaModel>? media,
    required String name,
    required String location,
    required String description,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.update({
      'info': {
        'media': media?.map((e) => e.toJson()).toList(),
        'name': name,
        'location': location,
        'description': description,
      },
    });

    _logger.log('Successful', name: 'updateProjectInfo');
  }

  Future<void> deleteProject({
    required String spaceId,
    required String id,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.remove();

    _logger.log('Successful', name: 'deleteProject');
  }

  Future<ProjectResponseModel?> getProjects({
    required String spaceId,
  }) async {
    final DatabaseReference reference = _getRef(spaceId);

    final DataSnapshot response = await reference.get();

    _logger.log('${response.value}', name: 'getProjects');

    if (response.exists) {
      return ProjectResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
