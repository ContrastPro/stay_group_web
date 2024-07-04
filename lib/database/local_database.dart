import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/users/auth_data_model.dart';

class LocalDB {
  const LocalDB._();

  static const LocalDB instance = LocalDB._();

  static const String _currentAuthBox = 'currentAuthBox';

  Future<void> ensureInitialized() async {
    await _initializeHive();
  }

  Future<void> _initializeHive() async {
    await Hive.openBox<String>(_currentAuthBox);
  }

  Future<void> saveCurrentAuth({
    required String email,
    required String password,
  }) async {
    final Box<String> currentAuthBox = Hive.box(_currentAuthBox);

    final AuthDataModel authData = AuthDataModel(
      email: email,
      password: password,
    );

    await currentAuthBox.put(
      'currentAuth',
      jsonEncode(authData.toJson()),
    );
  }

  Future<AuthDataModel?> getCurrentAuth() async {
    final Box<String> currentAuthBox = Hive.box(_currentAuthBox);

    final String? response = currentAuthBox.get('currentAuth');

    if (response != null) {
      return AuthDataModel.fromJson(
        jsonDecode(response),
      );
    }

    return null;
  }
}
