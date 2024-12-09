// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJ1aKe0F_4i5s4oIl-C9rA0aoXtW-6LMU',
    appId: '1:289484337931:web:91776a4f13e4ed3ba3a80e',
    messagingSenderId: '289484337931',
    projectId: 'dropapp-72220',
    authDomain: 'dropapp-72220.firebaseapp.com',
    storageBucket: 'dropapp-72220.firebasestorage.app',
    measurementId: 'G-4BD0HY38D6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQjdhhi42BzwjYDxpvDT--Han_tWAmdTI',
    appId: '1:289484337931:android:0ebdd9f1335d6ce1a3a80e',
    messagingSenderId: '289484337931',
    projectId: 'dropapp-72220',
    storageBucket: 'dropapp-72220.firebasestorage.app',
  );
}
