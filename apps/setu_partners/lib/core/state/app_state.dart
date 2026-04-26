import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class AppState extends ChangeNotifier {
  final _userService = UserService();

  UserModel? currentUser;
  bool isLoading = true;

  AppState() {
    _init();
  }

  Future<void> _init() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      currentUser = await _userService.fetchUserProfile(firebaseUser.uid);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    isLoading = true;
    notifyListeners();
    await _init();
  }
}