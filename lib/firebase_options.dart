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
    apiKey: 'AIzaSyCT9Fj4Z12mMmW44wfu8leNV025cD30Ie4',
    appId: '1:787238645564:web:7a415e35a9f2b8feeb3839',
    messagingSenderId: '787238645564',
    projectId: 'fly-up-28617',
    authDomain: 'fly-up-28617.firebaseapp.com',
    storageBucket: 'fly-up-28617.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCp2jV_L1V33wE2Hls-o6f1VcSR3YnCgr4',
    appId: '1:787238645564:android:e48f6919618fe6e4eb3839',
    messagingSenderId: '787238645564',
    projectId: 'fly-up-28617',
    storageBucket: 'fly-up-28617.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtNPL1g9AySwXCtoGXtMZcjiURZ0KlVnY',
    appId: '1:787238645564:ios:1c01244a81667685eb3839',
    messagingSenderId: '787238645564',
    projectId: 'fly-up-28617',
    storageBucket: 'fly-up-28617.appspot.com',
    androidClientId: '787238645564-7gaa9420p2lfkg63n01dmvdkqc18t6fn.apps.googleusercontent.com',
    iosClientId: '787238645564-rc2u2u9f5844ssphtlq3t6r6dt5a03o8.apps.googleusercontent.com',
    iosBundleId: 'com.example.flyUp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBtNPL1g9AySwXCtoGXtMZcjiURZ0KlVnY',
    appId: '1:787238645564:ios:0cfc615613ccfcb3eb3839',
    messagingSenderId: '787238645564',
    projectId: 'fly-up-28617',
    storageBucket: 'fly-up-28617.appspot.com',
    androidClientId: '787238645564-7gaa9420p2lfkg63n01dmvdkqc18t6fn.apps.googleusercontent.com',
    iosClientId: '787238645564-suanotpk8hb55agfmpq940cuq5gfsb4g.apps.googleusercontent.com',
    iosBundleId: 'com.example.flyUp.RunnerTests',
  );
}