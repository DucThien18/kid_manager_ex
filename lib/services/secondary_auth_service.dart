import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SecondaryAuthService {
  static const _appName = 'SecondaryAuth';

  Future<UserCredential> createUser({
    required String email,
    required String password,
  }) async {
    // 1️⃣ Init secondary app
    final secondaryApp = await Firebase.initializeApp(
      name: _appName,
      options: Firebase.app().options,
    );

    final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

    try {
      // 2️⃣ Create user
      final cred = await secondaryAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return cred;
    } finally {
      // 3️⃣ Cleanup (RẤT QUAN TRỌNG)
      await secondaryAuth.signOut();
      await secondaryApp.delete();
    }
  }
}