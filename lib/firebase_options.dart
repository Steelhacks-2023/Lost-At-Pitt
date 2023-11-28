// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

const String defaultError = "Unsupported platform. Please use Web, IOS, or Android";

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
class ProductionFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(defaultError);
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyByMdAHCU2PYpS69RCJGUhvkyvu5NCYIj8',
    appId: '1:780072412373:web:7895885a967148bdd0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    authDomain: 'steelhacks-2023-db.firebaseapp.com',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    measurementId: 'G-JZW90ZLJSC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCERe3j3efr-wf3lNFHwqM1E2Dpg4HKJ6Y',
    appId: '1:780072412373:android:8be28c803947082bd0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6ZUq_5_dagmiBo2rLxJKu56lOC0fGO4I',
    appId: '1:780072412373:ios:a567e58d75bb7015d0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    iosClientId: '780072412373-nm7lgj09mlfs7vb3f644amagt6e1nuf1.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostFoundSteelhacks',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6ZUq_5_dagmiBo2rLxJKu56lOC0fGO4I',
    appId: '1:780072412373:ios:a567e58d75bb7015d0ee5c',
    messagingSenderId: '780072412373',
    projectId: 'steelhacks-2023-db',
    storageBucket: 'steelhacks-2023-db.appspot.com',
    iosClientId: '780072412373-nm7lgj09mlfs7vb3f644amagt6e1nuf1.apps.googleusercontent.com',
    iosBundleId: 'com.example.lostFoundSteelhacks',
  );
}

class DevelopmentFirebaseOptions {
  static FirebaseOptions get currentPlatform {
      if (kIsWeb) return web;
      switch (defaultTargetPlatform) {        
        case TargetPlatform.android:
          throw UnsupportedError("No Android development environment as of now. Please test on web");
        case TargetPlatform.iOS:
          throw UnsupportedError("No IOS development environment as of now. Please test on web");
        default:
          throw UnsupportedError(defaultError);
      }
    }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCPatdhg87sBtlYPSkx4dUjJaijYQ-1IJ0",
    authDomain: "lost-at-pitt-dev.firebaseapp.com",
    projectId: "lost-at-pitt-dev",
    storageBucket: "lost-at-pitt-dev.appspot.com",
    messagingSenderId: "868037729371",
    appId: "1:868037729371:web:c6a8062e2444ae5883337e",
    measurementId: "G-VJ2X16H6N9"
  );

  /* Add other development options here. not really needed right now */
}