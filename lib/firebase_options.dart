// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBgnKjsYA8glr8jQ8oqlhYoYUw0v4BPlEk',
    appId: '1:174794732202:web:244ba86eab637d4f22d6d3',
    messagingSenderId: '174794732202',
    projectId: 'goodsstockmanager',
    authDomain: 'goodsstockmanager.firebaseapp.com',
    storageBucket: 'goodsstockmanager.appspot.com',
    measurementId: 'G-H68XBNYRS1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAO-0M5DmTlKIkUlQKyhKw8ZBvA1CiWUXE',
    appId: '1:174794732202:android:afd9d5a989e9ca8e22d6d3',
    messagingSenderId: '174794732202',
    projectId: 'goodsstockmanager',
    storageBucket: 'goodsstockmanager.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOHNvxexw73U7bc7xyLB_r4twDrkCoeVg',
    appId: '1:174794732202:ios:759357571e8a1f9a22d6d3',
    messagingSenderId: '174794732202',
    projectId: 'goodsstockmanager',
    storageBucket: 'goodsstockmanager.appspot.com',
    iosClientId: '174794732202-ghgh1q66v0okl97i6jharlc667ki9sn6.apps.googleusercontent.com',
    iosBundleId: 'com.example.stockmanager',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOHNvxexw73U7bc7xyLB_r4twDrkCoeVg',
    appId: '1:174794732202:ios:759357571e8a1f9a22d6d3',
    messagingSenderId: '174794732202',
    projectId: 'goodsstockmanager',
    storageBucket: 'goodsstockmanager.appspot.com',
    iosClientId: '174794732202-ghgh1q66v0okl97i6jharlc667ki9sn6.apps.googleusercontent.com',
    iosBundleId: 'com.example.stockmanager',
  );
}
