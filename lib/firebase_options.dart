// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyB4MDgduMYRrVdaOwBHYHleevdnBfNfeFs',
    appId: '1:98939857196:web:b1d370d138093f5e7c2489',
    messagingSenderId: '98939857196',
    projectId: 'nymblemusicapp',
    authDomain: 'nymblemusicapp.firebaseapp.com',
    storageBucket: 'nymblemusicapp.appspot.com',
    measurementId: 'G-JCKJL8JE5Y',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSrF0_xtIeF91kjXoAbqDcqKlVmJ1Ngq8',
    appId: '1:98939857196:android:d73504cb0d8567e37c2489',
    messagingSenderId: '98939857196',
    projectId: 'nymblemusicapp',
    storageBucket: 'nymblemusicapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAweD7JsnSwtP-jj8YuecEstJANFnt0j6k',
    appId: '1:98939857196:ios:f41562d96696a01d7c2489',
    messagingSenderId: '98939857196',
    projectId: 'nymblemusicapp',
    storageBucket: 'nymblemusicapp.appspot.com',
    iosBundleId: 'com.example.nymbleMusicApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAweD7JsnSwtP-jj8YuecEstJANFnt0j6k',
    appId: '1:98939857196:ios:e9af838c0a65198f7c2489',
    messagingSenderId: '98939857196',
    projectId: 'nymblemusicapp',
    storageBucket: 'nymblemusicapp.appspot.com',
    iosBundleId: 'com.example.nymbleMusicApp.RunnerTests',
  );
}
