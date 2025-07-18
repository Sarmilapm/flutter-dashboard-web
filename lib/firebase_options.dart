

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDpDBDCi-XX6SDg9AFF4FO60XBXwPLUlMg',
    authDomain: 'flutterdashboardweb-2b10e.firebaseapp.com',
    projectId: 'flutterdashboardweb-2b10e',
    storageBucket: 'flutterdashboardweb-2b10e.firebasestorage.app',
    messagingSenderId: '499354593659',
    appId: '1:499354593659:web:34178396ae49d37f2fb5de',
  );
}
