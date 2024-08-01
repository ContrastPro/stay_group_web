import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/repository_logger_service.dart';

class AuthRepository {
  static const RepositoryLogger _logger = RepositoryLogger(
    repositoryName: 'AuthRepository',
  );

  static final FirebaseAuth _api = FirebaseAuth.instance;

  Future<UserCredential?> emailLogIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential response = await _api.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.log(response.toString(), name: 'emailLogIn');

      return response;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'emailLogIn');
      return null;
    }
  }

  Future<UserCredential?> emailSignUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential response = await _api.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.log(response.toString(), name: 'emailSignUp');

      return response;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'emailSignUp');
      return null;
    }
  }

  Future<bool?> sendEmailVerification() async {
    try {
      await _api.currentUser!.sendEmailVerification();

      _logger.log('Successful', name: 'sendEmailVerification');

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'sendEmailVerification');
      return null;
    }
  }

  Future<bool?> passwordRecovery({
    required String email,
  }) async {
    try {
      await _api.sendPasswordResetEmail(email: email);

      _logger.log('Successful', name: 'passwordRecovery');

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'passwordRecovery');
      return null;
    }
  }

  User? currentUser() {
    final User? user = _api.currentUser;

    _logger.log(user.toString(), name: 'currentUser');

    return user;
  }

  StreamSubscription<User?> authChanges({
    required void Function() navigateToLogInPage,
  }) {
    final Stream<User?> userStream = _api.authStateChanges();

    return userStream.listen(
      (User? user) {
        if (user == null) {
          _logger.log('navigateToLogInPage', name: 'authChanges');

          return navigateToLogInPage();
        }
      },
    );
  }

  Future<bool?> updatePassword({
    required String password,
  }) async {
    try {
      await _api.currentUser!.updatePassword(password);

      _logger.log('Successful', name: 'updatePassword');

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'updatePassword');
      return null;
    }
  }

  Future<bool?> signOut() async {
    try {
      await _api.signOut();

      _logger.log('Successful', name: 'signOut');

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'signOut');
      return null;
    }
  }

  Future<bool?> deleteAccount() async {
    try {
      await _api.currentUser!.delete();

      _logger.log('Successful', name: 'deleteAccount');

      return true;
    } on FirebaseAuthException catch (e) {
      _logger.log(e.code, name: 'deleteAccount');
      return null;
    }
  }
}
