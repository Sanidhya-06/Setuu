// apps/setu_ngo/lib/core/services/ngo_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import 'storage_service.dart';

// ── Step Data Models ──────────────────────────────────────────────────────────

class NgoStep1Data {
  final String ngoName;
  final String email;
  final String phoneNumber;
  final String password;

  const NgoStep1Data({
    required this.ngoName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}

class NgoStep2Data {
  final String ngoType;
  final String registrationNumber;
  final String yearOfEstablishment;
  final String address;
  final String city;
  final String state;
  final String pincode;

  const NgoStep2Data({
    required this.ngoType,
    required this.registrationNumber,
    required this.yearOfEstablishment,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
  });
}

class NgoStep3Data {
  final File registrationCertificate;
  final File governmentIdProof;
  final File? additionalDocument;
  final String? websiteUrl;
  final String? socialMediaLink;

  const NgoStep3Data({
    required this.registrationCertificate,
    required this.governmentIdProof,
    this.additionalDocument,
    this.websiteUrl,
    this.socialMediaLink,
  });
}

// ── NgoService ────────────────────────────────────────────────────────────────

class NgoService {
  final AuthService _authService;
  final StorageService _storageService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NgoService({
    required AuthService authService,
    required StorageService storageService,
  })  : _authService = authService,
        _storageService = storageService;

  // ── Step 1 Validation ─────────────────────────────────────────────────────────

  void validateStep1(NgoStep1Data data) {
    if (data.ngoName.trim().isEmpty) throw Exception('NGO name is required.');
    if (data.email.trim().isEmpty) throw Exception('Email address is required.');
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(data.email.trim())) {
      throw Exception('Please enter a valid email address.');
    }
    if (data.phoneNumber.trim().isEmpty) throw Exception('Phone number is required.');
    if (data.password.length < 6) throw Exception('Password must be at least 6 characters.');
  }

  // ── Step 2 Validation ─────────────────────────────────────────────────────────

  void validateStep2(NgoStep2Data data) {
    if (data.ngoType.trim().isEmpty) throw Exception('Please select an NGO type / category.');
    if (data.registrationNumber.trim().isEmpty) throw Exception('Registration number is required.');
    if (data.yearOfEstablishment.trim().isEmpty) throw Exception('Year of establishment is required.');
    if (data.address.trim().isEmpty) throw Exception('Address is required.');
    if (data.city.trim().isEmpty) throw Exception('City is required.');
    if (data.state.trim().isEmpty) throw Exception('Please select a state.');
    if (!RegExp(r'^\d{6}$').hasMatch(data.pincode.trim())) {
      throw Exception('Please enter a valid 6-digit pincode.');
    }
  }

  // ── Step 3 Validation ─────────────────────────────────────────────────────────

  void validateStep3(NgoStep3Data data) {
    const maxBytes = 5 * 1024 * 1024;
    _validateFile(data.registrationCertificate, 'Registration certificate', maxBytes: maxBytes);
    _validateFile(data.governmentIdProof, 'Government ID proof', maxBytes: maxBytes);
    if (data.additionalDocument != null) {
      _validateFile(data.additionalDocument!, 'Additional document', maxBytes: maxBytes);
    }
  }

  void _validateFile(File file, String label, {required int maxBytes}) {
    final bytes = file.lengthSync();
    if (bytes == 0) throw Exception('$label file is empty.');
    if (bytes > maxBytes) throw Exception('$label must be under 5 MB.');
    final ext = file.path.split('.').last.toLowerCase();
    if (!['pdf', 'jpg', 'jpeg', 'png'].contains(ext)) {
      throw Exception('$label must be a PDF, JPG, or PNG file.');
    }
  }

  // ── Step 4: Submit (only Firebase touch in the entire signup flow) ────────────

  Future<void> submitApplication({
    required NgoStep1Data step1,
    required NgoStep2Data step2,
    required NgoStep3Data step3,
  }) async {
    String? uid;

    try {
      // 1. Create Firebase Auth account — uses name: to match setu_partners interface
      final credential = await _authService.signUp(
        name: step1.ngoName,       // ← matches AuthService.signUp(name:)
        email: step1.email,
        password: step1.password,
      );
      uid = credential?.user?.uid;

      // 2. Fake-upload documents (progress fires in UI, files go nowhere)
      await _storageService.uploadFile(
        file: step3.registrationCertificate,
        storagePath: 'ngo_documents/$uid/registration_certificate',
      );
      await _storageService.uploadFile(
        file: step3.governmentIdProof,
        storagePath: 'ngo_documents/$uid/government_id_proof',
      );
      if (step3.additionalDocument != null) {
        await _storageService.uploadFile(
          file: step3.additionalDocument!,
          storagePath: 'ngo_documents/$uid/additional_document',
        );
      }

      // 3. Write full registration to Firestore (no document URLs — files dropped)
      await _firestore.collection('ngo_registrations').doc(uid).set({
        'uid': uid,
        'registrationStatus': 'pending',
        'ngoName': step1.ngoName.trim(),
        'email': step1.email.trim(),
        'phoneNumber': step1.phoneNumber.trim(),
        'ngoType': step2.ngoType.trim(),
        'registrationNumber': step2.registrationNumber.trim(),
        'yearOfEstablishment': step2.yearOfEstablishment.trim(),
        'address': step2.address.trim(),
        'city': step2.city.trim(),
        'state': step2.state.trim(),
        'pincode': step2.pincode.trim(),
        if (step3.websiteUrl?.isNotEmpty == true) 'websiteUrl': step3.websiteUrl!.trim(),
        if (step3.socialMediaLink?.isNotEmpty == true) 'socialMediaLink': step3.socialMediaLink!.trim(),
        'submittedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Roll back Auth account so same email can be retried
      if (uid != null) {
        try { await _authService.deleteAccount(); } catch (_) {}
      }
      rethrow;
    }
  }

  // ── Fetch Registration ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> getRegistration(String uid) async {
    try {
      final doc = await _firestore.collection('ngo_registrations').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception('Failed to fetch registration details.');
    }
  }

  // ── Full Account Deletion ─────────────────────────────────────────────────────

  Future<void> deleteNgoAccount(String uid) async {
    final errors = <String>[];

    try { await _storageService.deleteNgoFolder(uid); }
    catch (e) { errors.add('Storage cleanup failed: $e'); }

    try {
      await Future.wait([
        _firestore.collection('ngo_registrations').doc(uid).delete(),
        _firestore.collection('users').doc(uid).delete(),
      ]);
    } catch (e) { errors.add('Firestore cleanup failed: $e'); }

    try { await _authService.deleteAccount(); }
    catch (e) { errors.add('Auth deletion failed: $e'); }

    if (errors.isNotEmpty) {
      throw Exception('Account deletion partially failed:\n${errors.join('\n')}');
    }
  }
}