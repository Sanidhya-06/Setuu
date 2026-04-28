// apps/setu_ngo/lib/features/dashboard/core/repository/dashboard_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_models.dart';

class DashboardRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── 1. Stat cards ─────────────────────────────────────────────────────────

  Future<NgoStats> fetchStats(String ngoId) async {
    try {
      final doc = await _db.collection('ngo_stats').doc(ngoId).get();
      if (!doc.exists) return NgoStats.empty();
      return NgoStats.fromDoc(doc);
    } catch (e) {
      throw Exception('Failed to load stats: $e');
    }
  }

  // ── 2. Trend line ─────────────────────────────────────────────────────────

  Future<List<TrendPoint>> fetchTrend(String ngoId) async {
    try {
      final now = DateTime.now();
      final months = List.generate(7, (i) {
        final d = DateTime(now.year, now.month - (6 - i));
        return '${d.year}-${d.month.toString().padLeft(2, '0')}';
      });

      final futures = months.map((month) => _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .where('month', isEqualTo: month)
          .get());

      final results = await Future.wait(futures);

      return List.generate(7, (i) {
        final docs = results[i].docs;
        final total =
            docs.fold<int>(0, (sum, d) => sum + ((d['count'] as int?) ?? 1));
        final parts = months[i].split('-');
        final dt =
            DateTime(int.parse(parts[0]), int.parse(parts[1]));
        return TrendPoint(
            month: months[i], label: _shortMonth(dt.month), count: total);
      });
    } catch (e) {
      throw Exception('Failed to load trend data: $e');
    }
  }

  // ── 3. Donut chart ────────────────────────────────────────────────────────

  Future<List<CategorySplit>> fetchCategorySplit(String ngoId) async {
    try {
      final snap = await _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .get();

      final counts = <IssueCategory, int>{};
      for (final doc in snap.docs) {
        final cat =
            IssueCategory.fromString(doc['category'] as String? ?? '');
        final c = (doc['count'] as int?) ?? 1;
        counts[cat] = (counts[cat] ?? 0) + c;
      }

      // Also count from volunteer reports collection
      final reportsSnap = await _db.collection('reports').get();
      for (final doc in reportsSnap.docs) {
        final cat =
            IssueCategory.fromString(doc['issueType'] as String? ?? '');
        counts[cat] = (counts[cat] ?? 0) + 1;
      }

      final total = counts.values.fold<int>(0, (a, b) => a + b);
      if (total == 0) return [];

      return IssueCategory.values
          .map((cat) {
            final count = counts[cat] ?? 0;
            return CategorySplit(
              category: cat,
              count: count,
              percentage: total == 0 ? 0 : (count / total) * 100,
            );
          })
          .where((s) => s.count > 0)
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
    } catch (e) {
      throw Exception('Failed to load category data: $e');
    }
  }

  // ── 4. Heatmap — merges issue_records (NGO) + reports (volunteers) ─────────
  //
  // issue_records  → uploaded by NGO/partners via the Data tab
  // reports        → submitted by volunteers via the "Report an Issue" screen
  //
  // Both land on the same heatmap so NGO admins see a unified picture.

  Future<List<HeatPoint>> fetchHeatPoints(String ngoId) async {
    try {
      // ── Source A: NGO issue_records ──────────────────────────────────────
      final issueSnap = await _db
          .collection('issue_records')
          .where('ngoId', isEqualTo: ngoId)
          .get();

      final map = <String, _HeatAccumulator>{};

      for (final doc in issueSnap.docs) {
        final name = doc['locationName'] as String? ?? '';
        final lat  = (doc['latitude']  as num?)?.toDouble() ?? 0;
        final lng  = (doc['longitude'] as num?)?.toDouble() ?? 0;
        final sev  = Severity.values
            .byName(doc['severity'] as String? ?? 'low');
        final cnt  = (doc['count'] as int?) ?? 1;
        final src  = HeatSource.ngoData;

        _merge(map, name, lat, lng, sev, cnt, src);
      }

      // ── Source B: Volunteer reports ──────────────────────────────────────
      // reports collection is shared — no ngoId filter needed.
      // Only include reports that have lat/lng (set when report is geocoded).
      final reportsSnap = await _db
          .collection('reports')
          .where('latitude', isNotEqualTo: 0)
          .get();

      for (final doc in reportsSnap.docs) {
        final lat = (doc['latitude']  as num?)?.toDouble() ?? 0;
        final lng = (doc['longitude'] as num?)?.toDouble() ?? 0;
        if (lat == 0 && lng == 0) continue;

        final name = doc['location'] as String? ?? 'Unknown';
        // Map issueType → severity
        final issueType = (doc['issueType'] as String? ?? '').toLowerCase();
        final sev = _issueTypeToSeverity(issueType);
        final src = HeatSource.volunteerReport;

        _merge(map, name, lat, lng, sev, 1, src);
      }

      return map.values.map((a) => a.toHeatPoint()).toList();
    } catch (e) {
      throw Exception('Failed to load heatmap data: $e');
    }
  }

  // ── 5. Top performing campaign ────────────────────────────────────────────

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

  // ── 6. Upcoming campaigns ─────────────────────────────────────────────────

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

  // ── 7. Recent activity ────────────────────────────────────────────────────

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

  // ── 8. NGO name ───────────────────────────────────────────────────────────

  Future<String> fetchNgoName(String ngoId) async {
    try {
      final doc =
          await _db.collection('ngo_registrations').doc(ngoId).get();
      return (doc.data()?['ngoName'] as String?) ?? 'Your NGO';
    } catch (_) {
      return 'Your NGO';
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _merge(
    Map<String, _HeatAccumulator> map,
    String name,
    double lat,
    double lng,
    Severity sev,
    int count,
    HeatSource source,
  ) {
    if (map.containsKey(name)) {
      final existing = map[name]!;
      map[name] = _HeatAccumulator(
        lat: existing.lat,
        lng: existing.lng,
        name: name,
        severity:
            sev.index > existing.severity.index ? sev : existing.severity,
        count: existing.count + count,
        // Track both sources
        sources: {...existing.sources, source},
      );
    } else {
      map[name] = _HeatAccumulator(
        lat: lat,
        lng: lng,
        name: name,
        severity: sev,
        count: count,
        sources: {source},
      );
    }
  }

  Severity _issueTypeToSeverity(String issueType) {
    switch (issueType) {
      case 'disaster relief':
      case 'health':
        return Severity.high;
      case 'environment':
      case 'animal welfare':
        return Severity.medium;
      default:
        return Severity.low;
    }
  }

  String _shortMonth(int month) => const [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][month];
}

// ── Internal accumulator (not exposed outside repository) ─────────────────────

class _HeatAccumulator {
  final double lat;
  final double lng;
  final String name;
  final Severity severity;
  final int count;
  final Set<HeatSource> sources;

  _HeatAccumulator({
    required this.lat,
    required this.lng,
    required this.name,
    required this.severity,
    required this.count,
    required this.sources,
  });

  HeatPoint toHeatPoint() => HeatPoint(
        latitude: lat,
        longitude: lng,
        locationName: name,
        severity: severity,
        count: count,
        sources: sources,
      );
}