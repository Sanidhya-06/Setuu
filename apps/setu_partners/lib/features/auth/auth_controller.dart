import 'package:flutter/material.dart';

/// AuthController manages authentication state across the app.
/// Hook up your real backend / Firebase / Supabase logic here.
class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  // ── Sign Up ──────────────────────────────────────────────────────────────
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with your real sign-up logic
      // e.g. await FirebaseAuth.instance.createUserWithEmailAndPassword(...)
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay

      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        _setError('Please fill in all fields.');
        return false;
      }

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Log In ───────────────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with your real login logic
      // e.g. await FirebaseAuth.instance.signInWithEmailAndPassword(...)
      await Future.delayed(const Duration(seconds: 2)); // Simulated delay

      if (email.isEmpty || password.isEmpty) {
        _setError('Please enter your email and password.');
        return false;
      }

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Google Sign In ───────────────────────────────────────────────────────
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with your Google sign-in logic
      // e.g. google_sign_in package + Firebase
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Apple Sign In ────────────────────────────────────────────────────────
  Future<bool> signInWithApple() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with your Apple sign-in logic
      // e.g. sign_in_with_apple package + Firebase
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Log Out ──────────────────────────────────────────────────────────────
  Future<void> logout() async {
    // TODO: Replace with your sign-out logic
    // e.g. await FirebaseAuth.instance.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}