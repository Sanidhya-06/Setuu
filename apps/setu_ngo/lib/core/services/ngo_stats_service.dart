import 'package:cloud_firestore/cloud_firestore.dart';

class NgoStatsService {
  final _db = FirebaseFirestore.instance;

  int _calculateImpactScore({
    required int totalReports,
    required int totalCampaigns,
    required int totalVolunteers,
  }) {
    double score =
        (totalReports * 0.4) +
        (totalCampaigns * 10 * 0.3) +
        (totalVolunteers * 0.3);

    return score.clamp(0, 100).round();
  }

  Future<void> updateStats(String uid) async {
    final now = DateTime.now();

    // 🔹 Current totals
    final reportsSnap = await _db
        .collection('issue_records')
        .where('ngoId', isEqualTo: uid)
        .get();

    final campaignsSnap = await _db
        .collection('campaigns')
        .where('ngoId', isEqualTo: uid)
        .get();

    int totalReports = reportsSnap.docs.fold(
        0, (sum, doc) => sum + ((doc['count'] ?? 0) as int));

    int totalCampaigns = campaignsSnap.size;

    int totalVolunteers = campaignsSnap.docs.fold(
        0, (sum, doc) => sum + ((doc['volunteerCount'] ?? 0) as int));

    // 🔹 Previous month calculation
    final prevMonth = DateTime(now.year, now.month - 1);

    final prevReportsSnap = await _db
        .collection('issue_records')
        .where('ngoId', isEqualTo: uid)
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(prevMonth.year, prevMonth.month, 1)))
        .where('date',
            isLessThan:
                Timestamp.fromDate(DateTime(prevMonth.year, prevMonth.month + 1, 1)))
        .get();

    final prevCampaignsSnap = await _db
        .collection('campaigns')
        .where('ngoId', isEqualTo: uid)
        .where('createdAt',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(prevMonth.year, prevMonth.month, 1)))
        .where('createdAt',
            isLessThan:
                Timestamp.fromDate(DateTime(prevMonth.year, prevMonth.month + 1, 1)))
        .get();

    int prevReports = prevReportsSnap.docs.fold(
        0, (sum, doc) => sum + ((doc['count'] ?? 0) as int));

    int prevCampaigns = prevCampaignsSnap.size;

    int prevVolunteers = prevCampaignsSnap.docs.fold(
        0, (sum, doc) => sum + ((doc['volunteerCount'] ?? 0) as int));

    // 🔹 Impact scores
    int impactScore = _calculateImpactScore(
      totalReports: totalReports,
      totalCampaigns: totalCampaigns,
      totalVolunteers: totalVolunteers,
    );

    int prevImpactScore = _calculateImpactScore(
      totalReports: prevReports,
      totalCampaigns: prevCampaigns,
      totalVolunteers: prevVolunteers,
    );

    // 🔹 Save
    await _db.collection('ngo_stats').doc(uid).set({
      'ngoId': uid,
      'totalReports': totalReports,
      'totalCampaigns': totalCampaigns,
      'totalVolunteers': totalVolunteers,
      'impactScore': impactScore,
      'prevMonthReports': prevReports,
      'prevMonthCampaigns': prevCampaigns,
      'prevMonthVolunteers': prevVolunteers,
      'prevMonthImpactScore': prevImpactScore,
      'updatedAt': Timestamp.now(),
    });
  }
}