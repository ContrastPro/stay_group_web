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
    String? companyId,
    String? projectId,
    String? section,
    String? floor,
    String? number,
    String? type,
    String? rooms,
    String? bathrooms,
    String? total,
    String? living,
    required String name,
    String? description,
    required String currency,
    String? price,
    String? depositVal,
    String? depositPct,
    int? period,
    DateTime? startInstallments,
    DateTime? endInstallments,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.set({
      'id': id,
      'info': {
        'companyId': companyId,
        'projectId': projectId,
        'section': section,
        'floor': floor,
        'number': number,
        'type': type,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'total': total,
        'living': living,
        'name': name,
        'description': description,
        'currency': currency,
        'price': price,
        'depositVal': depositVal,
        'depositPct': depositPct,
        'period': period,
        'startInstallments': startInstallments != null
            ? localToUtc(startInstallments, onlyUtcFormat: true)
            : null,
        'endInstallments': endInstallments != null
            ? localToUtc(endInstallments, onlyUtcFormat: true)
            : null,
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
    String? companyId,
    String? projectId,
    String? section,
    String? floor,
    String? number,
    String? type,
    String? rooms,
    String? bathrooms,
    String? total,
    String? living,
    required String name,
    String? description,
    required String currency,
    String? price,
    String? depositVal,
    String? depositPct,
    int? period,
    DateTime? startInstallments,
    DateTime? endInstallments,
    required String createdAt,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.update({
      'id': id,
      'info': {
        'companyId': companyId,
        'projectId': projectId,
        'section': section,
        'floor': floor,
        'number': number,
        'type': type,
        'rooms': rooms,
        'bathrooms': bathrooms,
        'total': total,
        'living': living,
        'name': name,
        'description': description,
        'currency': currency,
        'price': price,
        'depositVal': depositVal,
        'depositPct': depositPct,
        'period': period,
        'startInstallments': startInstallments != null
            ? localToUtc(startInstallments, onlyUtcFormat: true)
            : null,
        'endInstallments': endInstallments != null
            ? localToUtc(endInstallments, onlyUtcFormat: true)
            : null,
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
