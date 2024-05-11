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
    apiKey: 'AIzaSyAscqbn-O8ZENvFN6joumFOiT5sjw2f_Es',
    appId: '1:264604279241:web:c1325022c4c2b6e70d4818',
    messagingSenderId: '264604279241',
    projectId: 'titantalk-db559',
    authDomain: 'titantalk-db559.firebaseapp.com',
    storageBucket: 'titantalk-db559.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0oB-KhW51caDnFcYP9vVBTtdlw2e-500',
    appId: '1:264604279241:android:c7709cf8931042010d4818',
    messagingSenderId: '264604279241',
    projectId: 'titantalk-db559',
    storageBucket: 'titantalk-db559.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqZpymUYVLjcFr5KDpTh8uiSkI1ohS-gw',
    appId: '1:264604279241:ios:19d90a761655a1320d4818',
    messagingSenderId: '264604279241',
    projectId: 'titantalk-db559',
    storageBucket: 'titantalk-db559.appspot.com',
    iosBundleId: 'com.example.videoConf',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqZpymUYVLjcFr5KDpTh8uiSkI1ohS-gw',
    appId: '1:264604279241:ios:33b0bcab302819ae0d4818',
    messagingSenderId: '264604279241',
    projectId: 'titantalk-db559',
    storageBucket: 'titantalk-db559.appspot.com',
    iosBundleId: 'com.example.videoConf.RunnerTests',
  );
}
