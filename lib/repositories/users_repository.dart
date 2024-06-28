import 'package:firebase_database/firebase_database.dart';

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
    required String email,
    required String userId,
  }) async {
    final DatabaseReference reference = _getRef(userId);

    await reference.child('/info').set({
      'email': email,
      'id': userId,
    });

    _logger.log('Successful', name: 'createUser');
  }
}
