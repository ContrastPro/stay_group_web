import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../models/users/user_info_model.dart';
import '../models/users/user_model.dart';
import '../models/users/user_response_model.dart';
import '../services/repository_logger_service.dart';
import '../utils/helpers.dart';

class UsersRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'UsersRepository',
  );

  static final FirebaseDatabase _api = FirebaseDatabase.instance;

  DatabaseReference _getRef([String? userId]) {
    if (userId == null) {
      return _api.ref('users');
    }

    return _api.ref('users/$userId');
  }

  Future<void> createUser({
    required String userId,
    String? spaceId,
    required UserRole role,
    required String email,
    required String name,
    DateTime? dueDate,
  }) async {
    final DatabaseReference reference = _getRef(userId);

    await reference.set({
      'archived': false,
      'blocked': false,
      'id': userId,
      'spaceId': spaceId,
      'info': {
        'role': role.value,
        'email': email,
        'name': name,
        'billingPlan': 0,
      },
      'metadata': {
        'createdAt': localToUtc(currentTime()),
        'dueDate': dueDate != null ? localToUtc(dueDate) : null,
      },
    });

    _logger.log('Successful', name: 'createUser');
  }

  Future<UserModel?> getUser({
    required String userId,
  }) async {
    final DatabaseReference reference = _getRef(userId);

    final DataSnapshot response = await reference.get();

    if (response.exists) {
      _logger.log('${response.value}', name: 'getUser');

      return UserModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }

  Future<UserResponseModel?> getTeam({
    required String spaceId,
  }) async {
    final DatabaseReference reference = _getRef();

    final DataSnapshot response =
        await reference.orderByChild('spaceId').equalTo(spaceId).get();

    if (response.exists) {
      _logger.log('${response.value}', name: 'getTeam');

      return UserResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
