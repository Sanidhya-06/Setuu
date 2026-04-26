// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Current User ────────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign Up ──────────────────────────────────────────────────────────────────

  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Save display name right after account creation
    await credential.user?.updateDisplayName(name.trim());
    await credential.user?.reload();

    return credential;
  }

  // ── Log In ───────────────────────────────────────────────────────────────────

  Future<UserCredential?> logIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    return credential;
  }

  // ── Log Out ──────────────────────────────────────────────────────────────────

  Future<void> logOut() async {
    await _auth.signOut();
  }

  // ── Forgot Password ──────────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Delete Account ───────────────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }
}