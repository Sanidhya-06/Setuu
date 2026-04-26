import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final _db = FirebaseFirestore.instance;
  final _collection = 'users';

  // ── Save after onboarding completes ─────────────────────────────────────
  Future<void> saveUserProfile(UserModel user) async {
    await _db
        .collection(_collection)
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  // ── Fetch current user's profile ─────────────────────────────────────────
  Future<UserModel?> fetchUserProfile(String uid) async {
    final doc = await _db.collection(_collection).doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // ── Fetch all users (for heatmap coordinates) ────────────────────────────
  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _db
        .collection(_collection)
        .where('latitude', isNull: false)
        .get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }

  // ── Fetch users by interest (for Discover) ───────────────────────────────
  Future<List<UserModel>> fetchUsersByInterest(String interest) async {
    final snapshot = await _db
        .collection(_collection)
        .where('interests', arrayContains: interest)
        .get();
    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }

  // ── Stream current user (live updates) ──────────────────────────────────
  Stream<UserModel?> streamUserProfile(String uid) {
    return _db
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }
}