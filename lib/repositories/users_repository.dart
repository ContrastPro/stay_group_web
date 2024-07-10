import 'package:firebase_database/firebase_database.dart';

import '../models/users/user_info_model.dart';
import '../models/users/user_model.dart';
import '../services/repository_logger_service.dart';

class UsersRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'UsersRepository',
  );

  static final FirebaseDatabase _api = FirebaseDatabase.instance;

  DatabaseReference _getRef(String userId) {
    return _api.ref('users/$userId');
  }

  Future<void> createUser({
    required String userId,
    String? spaceId,
    required UserRole role,
    required String email,
  }) async {
    final DatabaseReference reference = _getRef(userId);

    await reference.child('/info').set({
      'id': userId,
      'spaceId': spaceId,
      'role': role.value,
      'email': email,
    });

    _logger.log('Successful', name: 'createUser');
  }

  Future<UserModel?> getUser({
    required String userId,
  }) async {
    final DatabaseReference reference = _getRef(userId);

    final DataSnapshot response = await reference.get();

    _logger.log('Successful', name: 'getUser');

    if (response.exists) {
      return UserModel.fromJson(
        response.value as Map<Object?, dynamic>,
      );
    }

    return null;
  }
}
