// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/insight_model.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  static const String _col = 'insights';

  CollectionReference<Map<String, dynamic>> get _ref =>
      FirebaseFirestore.instance.collection(_col);

  Future<String> saveInsight(InsightModel insight) async {
    final doc = await _ref.add(insight.toMap());
    return doc.id;
  }

  Stream<List<InsightModel>> insightsStream() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => InsightModel.fromMap(d.data(), id: d.id))
            .toList());
  }
}