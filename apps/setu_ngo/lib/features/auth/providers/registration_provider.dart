// apps/setu_ngo/lib/features/auth/providers/registration_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/ngo_service.dart';

class RegistrationProvider extends ChangeNotifier {
  final NgoService _ngoService = NgoService(
    authService: AuthService(),
    storageService: StorageService(),
  );

  // ── Step tracking ─────────────────────────────────────────────────────────────

  int _currentStep = 1;
  int get currentStep => _currentStep;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Step 1 fields ─────────────────────────────────────────────────────────────

  String ngoName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';
  String confirmPassword = '';

  // ── Step 2 fields ─────────────────────────────────────────────────────────────

  String ngoType = '';
  String registrationNumber = '';
  String yearOfEstablishment = '';
  String address = '';
  String city = '';
  String state = '';
  String pincode = '';

  // ── Step 3 fields ─────────────────────────────────────────────────────────────

  File? registrationCertificate;
  File? governmentIdProof;
  File? additionalDocument;
  String websiteUrl = '';
  String socialMediaLink = '';

  // Upload progress per file (null = not started, 0.0–1.0 = uploading, 1.0 = done)
  double? certProgress;
  double? govIdProgress;
  double? additionalDocProgress;

  // ── Update helpers ────────────────────────────────────────────────────────────

  void updateField(void Function() updater) {
    updater();
    _errorMessage = null;
    notifyListeners();
  }

  // Simulates file upload progress in the UI — file is never sent anywhere
  Future<void> pickAndFakeUpload({
    required File file,
    required String slot, // 'cert' | 'govId' | 'additional'
  }) async {
    // Set file, reset progress
    updateField(() {
      if (slot == 'cert') { registrationCertificate = file; certProgress = 0.0; }
      if (slot == 'govId') { governmentIdProof = file; govIdProgress = 0.0; }
      if (slot == 'additional') { additionalDocument = file; additionalDocProgress = 0.0; }
    });

    // Drive StorageService fake upload — captures progress ticks into state
    await StorageService().uploadFile(
      file: file,
      storagePath: 'fake/$slot',
      onProgress: (p) {
        if (slot == 'cert') certProgress = p;
        if (slot == 'govId') govIdProgress = p;
        if (slot == 'additional') additionalDocProgress = p;
        notifyListeners();
      },
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────────

  bool validateAndNextStep1() {
    try {
      _ngoService.validateStep1(NgoStep1Data(
        ngoName: ngoName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      ));
      if (password != confirmPassword) throw Exception('Passwords do not match.');
      _currentStep = 2;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }

  bool validateAndNextStep2() {
    try {
      _ngoService.validateStep2(NgoStep2Data(
        ngoType: ngoType,
        registrationNumber: registrationNumber,
        yearOfEstablishment: yearOfEstablishment,
        address: address,
        city: city,
        state: state,
        pincode: pincode,
      ));
      _currentStep = 3;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }

  bool validateAndNextStep3() {
    try {
      if (registrationCertificate == null) throw Exception('Please upload your registration certificate.');
      if (governmentIdProof == null) throw Exception('Please upload your government ID proof.');
      // Only allow proceeding once both required uploads are complete
      if (certProgress != 1.0) throw Exception('Please wait for certificate upload to complete.');
      if (govIdProgress != 1.0) throw Exception('Please wait for ID proof upload to complete.');
      _currentStep = 4;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = _clean(e);
      notifyListeners();
      return false;
    }
  }

  void goBack() {
    if (_currentStep > 1) {
      _currentStep--;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ── Final Submit ──────────────────────────────────────────────────────────────

  Future<void> submitApplication() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _ngoService.submitApplication(
        step1: NgoStep1Data(
          ngoName: ngoName,
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        ),
        step2: NgoStep2Data(
          ngoType: ngoType,
          registrationNumber: registrationNumber,
          yearOfEstablishment: yearOfEstablishment,
          address: address,
          city: city,
          state: state,
          pincode: pincode,
        ),
        step3: NgoStep3Data(
          registrationCertificate: registrationCertificate!,
          governmentIdProof: governmentIdProof!,
          additionalDocument: additionalDocument,
          websiteUrl: websiteUrl.isEmpty ? null : websiteUrl,
          socialMediaLink: socialMediaLink.isEmpty ? null : socialMediaLink,
        ),
      );
      _isSubmitted = true;
    } catch (e) {
      _errorMessage = _clean(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}