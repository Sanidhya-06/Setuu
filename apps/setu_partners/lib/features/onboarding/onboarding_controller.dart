import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/models/user_model.dart';
import '../../core/services/user_service.dart';

class OnboardingController extends ChangeNotifier {
  int _currentPage = 0;
  final PageController pageController = PageController();
  final _userService = UserService();

  // Page 1 — interests
  final List<String> allInterests = [
    'Environment', 'Education', 'Health',
    'Animal Welfare', 'Community', 'Disaster Relief',
  ];
  final Set<String> selectedInterests = {};

  // Page 2 — location
  String location = 'Tap GPS icon to detect';
  double? latitude;
  double? longitude;
  bool isLoadingLocation = false;
  String? locationError;

  // Save state
  bool isSaving = false;
  String? saveError;

  int get currentPage => _currentPage;
  int get totalPages => 3;

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void toggleInterest(String interest) {
    selectedInterests.contains(interest)
        ? selectedInterests.remove(interest)
        : selectedInterests.add(interest);
    notifyListeners();
  }

  bool isSelected(String interest) => selectedInterests.contains(interest);

  void updateLocation(String newLocation) {
    location = newLocation;
    locationError = null;
    notifyListeners();
  }

  Future<void> detectCurrentLocation() async {
    isLoadingLocation = true;
    locationError = null;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError = 'Location services are disabled.';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError = 'Location permission denied.';
          isLoadingLocation = false;
          notifyListeners();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError = 'Enable location permission in app settings.';
        isLoadingLocation = false;
        notifyListeners();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Store raw coords for heatmap
      latitude  = position.latitude;
      longitude = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [place.locality, place.administrativeArea, place.country]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        location = parts.join(', ');
      } else {
        location = '${position.latitude}, ${position.longitude}';
      }
    } catch (e) {
      locationError = 'Could not detect location. Try again.';
    }

    isLoadingLocation = false;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  // ── Called on final onboarding step ─────────────────────────────────────
  Future<void> finish(BuildContext context) async {
    isSaving = true;
    saveError = null;
    notifyListeners();

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) throw Exception('No logged-in user found.');

      final user = UserModel(
        uid:       firebaseUser.uid,
        name:      firebaseUser.displayName ?? '',
        email:     firebaseUser.email ?? '',
        interests: selectedInterests.toList(),
        location:  location,
        latitude:  latitude,
        longitude: longitude,
        createdAt: DateTime.now(),
      );

      await _userService.saveUserProfile(user);

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      saveError = 'Failed to save profile. Please try again.';
    }

    isSaving = false;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}