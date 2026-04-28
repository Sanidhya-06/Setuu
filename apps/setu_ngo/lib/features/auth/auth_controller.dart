import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<bool> login() async {
  _errorMessage = null;
  _isLoading = true;
  notifyListeners();

  final email = emailController.text.trim();
  final password = passwordController.text;

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    _isLoading = false;
    notifyListeners();
    return true;

  } on FirebaseAuthException catch (e) {
    _isLoading = false;

    // 🔥 Handle common errors properly
    switch (e.code) {
      case 'user-not-found':
        _errorMessage = 'No account found for this email';
        break;
      case 'wrong-password':
        _errorMessage = 'Incorrect password';
        break;
      case 'invalid-email':
        _errorMessage = 'Invalid email format';
        break;
      case 'user-disabled':
        _errorMessage = 'This account has been disabled';
        break;
      default:
        _errorMessage = 'Login failed. Try again.';
    }

    notifyListeners();
    return false;
  } catch (_) {
    _isLoading = false;
    _errorMessage = 'Something went wrong';
    notifyListeners();
    return false;
  }
}

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}