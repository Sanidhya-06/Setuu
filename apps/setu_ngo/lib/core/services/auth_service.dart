// apps/setu_ngo/lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Current User ──────────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign Up ───────────────────────────────────────────────────────────────────
  // Mirrors setu_partners signature (name, email, password).
  // Called ONLY at Step 4 submission — never before.
  // On any failure after account creation, rolls back the Auth user
  // so the same email can be retried.

  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential? credential;

    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      // Minimal users doc — role guard for the shared backend
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email.trim(),
        'role': 'ngo',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } on FirebaseAuthException catch (e) {
      await credential?.user?.delete();
      throw _mapAuthException(e);
    } catch (e) {
      await credential?.user?.delete();
      throw Exception('Sign up failed. Please try again.');
    }
  }

  // ── Log In ────────────────────────────────────────────────────────────────────

  Future<UserCredential?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (e) {
      throw Exception('Login failed. Please try again.');
    }
  }

  // ── Log Out ───────────────────────────────────────────────────────────────────

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to log out. Please try again.');
    }
  }

  // ── Forgot Password ───────────────────────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  // ── Delete Account ────────────────────────────────────────────────────────────
  // Only deletes the Auth account.
  // Full cleanup (Firestore + Storage) is coordinated by NgoService.

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    }
  }

  // ── Error Mapping ─────────────────────────────────────────────────────────────

  Exception _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('This email is already registered. Please log in.');
      case 'invalid-email':
        return Exception('Please enter a valid email address.');
      case 'weak-password':
        return Exception('Password must be at least 6 characters.');
      case 'user-not-found':
        return Exception('No account found with this email.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please wait and try again.');
      case 'requires-recent-login':
        return Exception('Please log in again before deleting your account.');
      case 'network-request-failed':
        return Exception('No internet connection. Please check your network.');
      default:
        return Exception(e.message ?? 'An unexpected error occurred.');
    }
  }
}