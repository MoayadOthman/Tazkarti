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
    apiKey: 'AIzaSyAL-oRaGssV771-lPvtr8fgigr55DCdjtk',
    appId: '1:260880272383:web:1c6b1af23dd000bbdaf5ca',
    messagingSenderId: '260880272383',
    projectId: 'fireecommerce-11e32',
    authDomain: 'fireecommerce-11e32.firebaseapp.com',
    storageBucket: 'fireecommerce-11e32.appspot.com',
    measurementId: 'G-53H3W3KY2T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9HyHNpaNx5g96PQZIbFzcm_z958nBV_w',
    appId: '1:260880272383:android:0785f9f191c7fe0ddaf5ca',
    messagingSenderId: '260880272383',
    projectId: 'fireecommerce-11e32',
    storageBucket: 'fireecommerce-11e32.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDVnFYKXjzHCyn3_hZbW-8Fhj7jUd85RVg',
    appId: '1:260880272383:ios:7f82c8c8e5f281d2daf5ca',
    messagingSenderId: '260880272383',
    projectId: 'fireecommerce-11e32',
    storageBucket: 'fireecommerce-11e32.appspot.com',
    iosClientId: '260880272383-51niljjitf2ctqvh7fkkrmo4eoua7lj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.wadiny',
  );
}
