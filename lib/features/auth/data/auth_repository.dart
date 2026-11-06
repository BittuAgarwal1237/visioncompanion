import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInCancelled implements Exception {
  const SignInCancelled();
}

class AuthRepository {
  AuthRepository(this._auth, this._google);

  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  Stream<User?> get authChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> register(String name, String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await result.user?.updateDisplayName(name.trim());
    await result.user?.reload();
  }

  Future<void> signInWithGoogle() async {
    final account = await _google.signIn();
    if (account == null) {
      throw const SignInCancelled();
    }
    final tokens = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: tokens.accessToken,
      idToken: tokens.idToken,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }
}
