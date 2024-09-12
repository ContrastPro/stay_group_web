// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdHD6Xu59A0m4kULgJ-rKCF7R7Z6KCfYE',
    authDomain: 'stay-group.firebaseapp.com',
    databaseURL: 'https://stay-group-default-rtdb.europe-west1.firebasedatabase.app',
    projectId: 'stay-group',
    storageBucket: 'stay-group.appspot.com',
    messagingSenderId: '101656628568',
    appId: '1:101656628568:web:70d4b77cfd9a13ff90292d',
    measurementId: 'G-G41YY9Q3WD',
  );
}
