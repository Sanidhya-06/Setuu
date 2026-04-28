import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ngo_profile_model.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<NgoProfile> fetchProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    final snap = await _db
        .collection('ngo_registrations')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) throw Exception('Profile not found');

    return NgoProfile.fromJson(snap.docs.first.data());
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Not logged in');

    final snap = await _db
        .collection('ngo_registrations')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) throw Exception('Profile not found');

    await snap.docs.first.reference.update({
      'profileImageUrl': imageUrl,
    });
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}