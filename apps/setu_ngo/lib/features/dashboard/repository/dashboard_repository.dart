// apps/setu_ngo/lib/features/dashboard/repositories/dashboard_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_models.dart';

class DashboardRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── 1. Stat cards — single read from ngo_stats ───────────────────────────────

  Future<NgoStats> fetchStats(String ngoId) async {
    try {
      final doc = await _db.collection('ngo_stats').doc(ngoId).get();
      if (!doc.exists) return NgoStats.empty();
      return NgoStats.fromDoc(doc);
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }

  // ── 2. Trend line — issue_records grouped by month, last 7 months ────────────

  Future<List<TrendPoint>> fetchTrend(String ngoId) async {
    try {
      // Build list of last 7 YYYY-MM strings
      final now = DateTime.now();
      final months = List.generate(7, (i) {
        final d = DateTime(now.year, now.month - (6 - i));
        return '${d.year}-${d.month.toString().padLeft(2, '0')}';
      });

      // One query per month (Firestore can't group-by natively)
      // Parallel fetch for speed
      final futures = months.map((month) => _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .where('month', isEqualTo: month)
          .get());

      final results = await Future.wait(futures);

      return List.generate(7, (i) {
        final docs = results[i].docs;
        final total = docs.fold<int>(
          0, (sum, d) => sum + ((d['count'] as int?) ?? 1));
        // Label: short month name
        final parts = months[i].split('-');
        final dt = DateTime(int.parse(parts[0]), int.parse(parts[1]));
        final label = _shortMonth(dt.month);
        return TrendPoint(month: months[i], label: label, count: total);
      });
    } catch (e) {
      throw Exception('Failed to load trend data: $e');
    }
  }

  // ── 3. Donut chart — sum by category ─────────────────────────────────────────

  Future<List<CategorySplit>> fetchCategorySplit(String ngoId) async {
    try {
      final snap = await _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .get();

      final counts = <IssueCategory, int>{};
      for (final doc in snap.docs) {
        final cat = IssueCategory.fromString(doc['category'] as String? ?? '');
        final c = (doc['count'] as int?) ?? 1;
        counts[cat] = (counts[cat] ?? 0) + c;
      }

      final total = counts.values.fold<int>(0, (a, b) => a + b);
      if (total == 0) return [];

      return IssueCategory.values.map((cat) {
        final count = counts[cat] ?? 0;
        return CategorySplit(
          category: cat,
          count: count,
          percentage: total == 0 ? 0 : (count / total) * 100,
        );
      }).where((s) => s.count > 0).toList()
        ..sort((a, b) => b.count.compareTo(a.count));
    } catch (e) {
      throw Exception('Failed to load category data: $e');
    }
  }

  // ── 4. Heatmap — lat/lng + severity from issue_records ───────────────────────

  Future<List<HeatPoint>> fetchHeatPoints(String ngoId) async {
    try {
      final snap = await _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .get();

      // Group by locationName — aggregate count per location
      final map = <String, HeatPoint>{};
      for (final doc in snap.docs) {
        final name = doc['locationName'] as String? ?? '';
        final lat  = (doc['latitude']  as num?)?.toDouble() ?? 0;
        final lng  = (doc['longitude'] as num?)?.toDouble() ?? 0;
        final sev  = Severity.values.byName(doc['severity'] as String? ?? 'low');
        final cnt  = (doc['count'] as int?) ?? 1;

        if (map.containsKey(name)) {
          // Keep highest severity, accumulate count
          final existing = map[name]!;
          map[name] = HeatPoint(
            latitude: existing.latitude,
            longitude: existing.longitude,
            locationName: name,
            severity: sev.index > existing.severity.index ? sev : existing.severity,
            count: existing.count + cnt,
          );
        } else {
          map[name] = HeatPoint(
            latitude: lat, longitude: lng,
            locationName: name, severity: sev, count: cnt,
          );
        }
      }
      return map.values.toList();
    } catch (e) {
      throw Exception('Failed to load heatmap data: $e');
    }
  }

  // ── 5. Top performing campaign ────────────────────────────────────────────────

  Future<Campaign?> fetchTopCampaign(String ngoId) async {
    try {
      final snap = await _db
          .collection('campaigns')
          .where('ngoId', isEqualTo: ngoId)
          .orderBy('volunteerCount', descending: true)
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;
      return Campaign.fromDoc(snap.docs.first);
    } catch (e) {
      throw Exception('Failed to load top campaign: $e');
    }
  }

  // ── 6. Upcoming campaigns ─────────────────────────────────────────────────────

  Future<List<Campaign>> fetchUpcomingCampaigns(String ngoId) async {
    try {
      final snap = await _db
          .collection('campaigns')
          .where('ngoId', isEqualTo: ngoId)
          .where('status', isEqualTo: 'upcoming')
          .orderBy('startDate')
          .limit(5)
          .get();

      return snap.docs.map(Campaign.fromDoc).toList();
    } catch (e) {
      throw Exception('Failed to load upcoming campaigns: $e');
    }
  }

  // ── 7. Recent activity — from data_uploads ────────────────────────────────────

  Future<List<RecentActivity>> fetchRecentActivity(String ngoId) async {
    try {
      final snap = await _db
          .collection('data_uploads')
          .where('ngoId', isEqualTo: ngoId)
          .orderBy('uploadedAt', descending: true)
          .limit(5)
          .get();

      return snap.docs.map(RecentActivity.fromDoc).toList();
    } catch (e) {
      throw Exception('Failed to load recent activity: $e');
    }
  }

  // ── 8. NGO name — from ngo_registrations ─────────────────────────────────────

  Future<String> fetchNgoName(String ngoId) async {
    try {
      final doc = await _db.collection('ngo_registrations').doc(ngoId).get();
      return (doc.data()?['ngoName'] as String?) ?? 'Your NGO';
    } catch (_) {
      return 'Your NGO';
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  String _shortMonth(int month) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][month];
}