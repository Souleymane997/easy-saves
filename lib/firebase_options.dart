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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBb09_1yTRRcNwENxlnaH-_4rjJKv5vQCo',
    appId: '1:651157417957:web:d8c3c34daba76c2cdb490c',
    messagingSenderId: '651157417957',
    projectId: 'easy-save-49d86',
    authDomain: 'easy-save-49d86.firebaseapp.com',
    storageBucket: 'easy-save-49d86.firebasestorage.app',
    measurementId: 'G-SEEE3W8THC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_kHyWZcpMcZ8t-V3v7PVmANbursrhmWI',
    appId: '1:651157417957:android:1d1c59abed48526edb490c',
    messagingSenderId: '651157417957',
    projectId: 'easy-save-49d86',
    storageBucket: 'easy-save-49d86.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-QRlmFu95iRqZV3U4NX9lC6xcL04xbrU',
    appId: '1:651157417957:ios:89fb4071a4d2c1acdb490c',
    messagingSenderId: '651157417957',
    projectId: 'easy-save-49d86',
    storageBucket: 'easy-save-49d86.firebasestorage.app',
    iosBundleId: 'com.example.easySaves',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-QRlmFu95iRqZV3U4NX9lC6xcL04xbrU',
    appId: '1:651157417957:ios:89fb4071a4d2c1acdb490c',
    messagingSenderId: '651157417957',
    projectId: 'easy-save-49d86',
    storageBucket: 'easy-save-49d86.firebasestorage.app',
    iosBundleId: 'com.example.easySaves',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBb09_1yTRRcNwENxlnaH-_4rjJKv5vQCo',
    appId: '1:651157417957:web:0eec071c75cabafddb490c',
    messagingSenderId: '651157417957',
    projectId: 'easy-save-49d86',
    authDomain: 'easy-save-49d86.firebaseapp.com',
    storageBucket: 'easy-save-49d86.firebasestorage.app',
    measurementId: 'G-VEDP9FQVBL',
  );
}
