import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/calculations/calculation_response_model.dart';
import '../services/repository_logger_service.dart';
import '../utils/helpers.dart';

class CalculationsRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'CalculationsRepository',
  );

  static final FirebaseDatabase _api = FirebaseDatabase.instance;

  DatabaseReference _getRef(
    String spaceId, {
    String? id,
  }) {
    if (id == null) {
      return _api.ref('calculations/$spaceId');
    }

    return _api.ref('calculations/$spaceId/$id');
  }

  Future<void> createCalculation({
    required String spaceId,
    required String id,
    required String name,
    required String description,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.set({
      'id': id,
      'info': {
        'name': name,
        'description': description,
      },
      'metadata': {
        'createdAt': localToUtc(currentTime()),
      },
    });

    _logger.log('Successful', name: 'createCalculation');
  }

  Future<void> updateCalculation({
    required String spaceId,
    required String id,
    required String name,
    required String description,
    required String createdAt,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.update({
      'id': id,
      'info': {
        'name': name,
        'description': description,
      },
      'metadata': {
        'createdAt': createdAt,
      },
    });

    _logger.log('Successful', name: 'updateCalculation');
  }

  Future<void> deleteCalculation({
    required String spaceId,
    required String id,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.remove();

    _logger.log('Successful', name: 'deleteCalculation');
  }

  Future<CalculationResponseModel?> getCalculations({
    required String spaceId,
  }) async {
    final DatabaseReference reference = _getRef(spaceId);

    final DataSnapshot response = await reference.get();

    _logger.log('${response.value}', name: 'getCalculations');

    if (response.exists) {
      return CalculationResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
