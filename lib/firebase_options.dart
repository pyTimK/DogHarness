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
    apiKey: 'AIzaSyCJkMioIa_MTsLHLk9ygmGl-Dm5eceOlag',
    appId: '1:440800884304:web:f1b6739bcb59e791e1c355',
    messagingSenderId: '440800884304',
    projectId: 'dogt-app',
    authDomain: 'dogt-app.firebaseapp.com',
    storageBucket: 'dogt-app.appspot.com',
    measurementId: 'G-L3HCKM2W6X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBD3K6X_klxF74mdYRLCqtNV18Abpw09ps',
    appId: '1:440800884304:android:6b18de199cbafcb6e1c355',
    messagingSenderId: '440800884304',
    projectId: 'dogt-app',
    storageBucket: 'dogt-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-Esx8X5_O8M0tIByOCIXC0lf9Dk8N_jo',
    appId: '1:440800884304:ios:e8c09cb7456d4925e1c355',
    messagingSenderId: '440800884304',
    projectId: 'dogt-app',
    storageBucket: 'dogt-app.appspot.com',
    iosClientId: '440800884304-ecp47iihpgtq777jbdieu37jlkuctu3j.apps.googleusercontent.com',
    iosBundleId: 'com.example.bluetoothAppTest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-Esx8X5_O8M0tIByOCIXC0lf9Dk8N_jo',
    appId: '1:440800884304:ios:e8c09cb7456d4925e1c355',
    messagingSenderId: '440800884304',
    projectId: 'dogt-app',
    storageBucket: 'dogt-app.appspot.com',
    iosClientId: '440800884304-ecp47iihpgtq777jbdieu37jlkuctu3j.apps.googleusercontent.com',
    iosBundleId: 'com.example.bluetoothAppTest',
  );
}
