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

  DatabaseReference _getRef([String? id]) {
    if (id == null) {
      return _api.ref('users');
    }

    return _api.ref('users/$id');
  }

  Future<void> createUser({
    required String id,
    String? userId,
    String? spaceId,
    required String email,
    String? presignedPassword,
    required UserRole role,
    required String name,
    DateTime? dueDate,
  }) async {
    final DatabaseReference reference = _getRef(id);

    final Map<String, dynamic> formData = {
      'archived': false,
      'blocked': false,
      'id': id,
    };

    if (role == UserRole.manager) {
      formData.addEntries([
        MapEntry('userId', userId),
        MapEntry('credential', {
          'email': email,
        }),
        MapEntry('info', {
          'role': role.value,
          'name': name,
          'billingPlan': 0,
        }),
        MapEntry('metadata', {
          'createdAt': localToUtc(currentTime()),
          'dueDate': localToUtc(dueDate!),
        }),
      ]);
    }

    if (role == UserRole.worker) {
      formData.addEntries([
        MapEntry('spaceId', spaceId),
        MapEntry('credential', {
          'email': email,
          'presignedPassword': presignedPassword,
        }),
        MapEntry('info', {
          'role': role.value,
          'name': name,
        }),
        MapEntry('metadata', {
          'createdAt': localToUtc(currentTime()),
        }),
      ]);
    }

    await reference.set(formData);

    _logger.log('Successful', name: 'createUser');
  }

  Future<UserModel?> getUserById({
    required String userId,
  }) async {
    final DatabaseReference reference = _getRef();

    final DataSnapshot response =
        await reference.orderByChild('userId').equalTo(userId).get();

    _logger.log('${response.value}', name: 'getUserById');

    if (response.exists) {
      final UserResponseModel userResponse = UserResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );

      return userResponse.users.first;
    }

    return null;
  }

  Future<UserModel?> getUserByEmail({
    required String email,
  }) async {
    final DatabaseReference reference = _getRef();

    final DataSnapshot response =
        await reference.orderByChild('credential/email').equalTo(email).get();

    _logger.log('${response.value}', name: 'getUserByEmail');

    if (response.exists) {
      final UserResponseModel userResponse = UserResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );

      return userResponse.users.first;
    }

    return null;
  }

  StreamSubscription<DatabaseEvent> userChanges({
    required String id,
    required void Function(UserModel) userUpdates,
  }) {
    final DatabaseReference reference = _getRef(id);

    final Stream<DatabaseEvent> userStream = reference.onValue;

    return userStream.listen(
      (DatabaseEvent event) {
        final UserModel userData = UserModel.fromJson(
          event.snapshot.value as Map<Object?, dynamic>,
        );

        _logger.log('${event.snapshot.value}', name: 'userChanges');

        userUpdates(userData);
      },
    );
  }

  Future<void> activateUser({
    required bool archived,
    required bool blocked,
    required String id,
    required String userId,
    required String spaceId,
    required String email,
    required UserRole role,
    required String name,
    required String createdAt,
  }) async {
    final DatabaseReference reference = _getRef(id);

    await reference.set({
      'archived': archived,
      'blocked': blocked,
      'id': id,
      'userId': userId,
      'spaceId': spaceId,
      'credential': {
        'email': email,
      },
      'info': {
        'role': role.value,
        'name': name,
      },
      'metadata': {
        'createdAt': createdAt,
      }
    });

    _logger.log('Successful', name: 'activateUser');
  }

  Future<void> updateUserArchive({
    required String id,
    required bool archived,
  }) async {
    final DatabaseReference reference = _getRef(id);

    await reference.update({
      'archived': archived,
    });

    _logger.log('Successful', name: 'updateUserArchive');
  }

  Future<void> updateUserInfo({
    required String id,
    required UserRole role,
    required String name,
    int? billingPlan,
  }) async {
    final DatabaseReference reference = _getRef(id);

    await reference.update({
      'info': {
        'role': role.value,
        'name': name,
        'billingPlan': billingPlan,
      },
    });

    _logger.log('Successful', name: 'updateUserInfo');
  }

  Future<void> deleteUser({
    required String id,
  }) async {
    final DatabaseReference reference = _getRef(id);

    await reference.remove();

    _logger.log('Successful', name: 'deleteUser');
  }

  Future<UserResponseModel?> getUserTeam({
    required String spaceId,
  }) async {
    final DatabaseReference reference = _getRef();

    final DataSnapshot response =
        await reference.orderByChild('spaceId').equalTo(spaceId).get();

    _logger.log('${response.value}', name: 'getUserTeam');

    if (response.exists) {
      return UserResponseModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
