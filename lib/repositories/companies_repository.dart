import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/companies/company_response_model.dart';
import '../services/repository_logger_service.dart';
import '../utils/helpers.dart';

class CompaniesRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'CompaniesRepository',
  );

  static final FirebaseDatabase _api = FirebaseDatabase.instance;

  DatabaseReference _getRef(
    String spaceId, {
    String? id,
  }) {
    if (id == null) {
      return _api.ref('companies/$spaceId');
    }

    return _api.ref('companies/$spaceId/$id');
  }

  Future<void> createCompany({
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

    _logger.log('Successful', name: 'createCompany');
  }

  Future<void> updateCompanyInfo({
    required String spaceId,
    required String id,
    required String name,
    required String description,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.update({
      'info': {
        'name': name,
        'description': description,
      },
    });

    _logger.log('Successful', name: 'updateCompanyInfo');
  }

  Future<void> deleteCompany({
    required String spaceId,
    required String id,
  }) async {
    final DatabaseReference reference = _getRef(
      spaceId,
      id: id,
    );

    await reference.remove();

    _logger.log('Successful', name: 'deleteCompany');
  }

  Future<CompanyResponseModel?> getCompanies({
    required String spaceId,
  }) async {
    final DatabaseReference reference = _getRef(spaceId);

    final DataSnapshot response = await reference.get();

    _logger.log('${response.value}', name: 'getCompanies');

    if (response.exists) {
      return CompanyResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
