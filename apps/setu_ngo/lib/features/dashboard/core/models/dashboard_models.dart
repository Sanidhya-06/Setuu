// apps/setu_ngo/lib/features/dashboard/core/models/dashboard_models.dart

import 'package:cloud_firestore/cloud_firestore.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum IssueCategory {
  environment,
  education,
  health,
  community,
  others;

  String get label => switch (this) {
        IssueCategory.environment => 'Environment',
        IssueCategory.education   => 'Education',
        IssueCategory.health      => 'Health',
        IssueCategory.community   => 'Community',
        IssueCategory.others      => 'Others',
      };

  static IssueCategory fromString(String s) => switch (s.toLowerCase()) {
        'environment'    => IssueCategory.environment,
        'education'      => IssueCategory.education,
        'health'         => IssueCategory.health,
        'community'      => IssueCategory.community,
        'animal welfare' => IssueCategory.community, // map to nearest
        'disaster relief'=> IssueCategory.others,
        _                => IssueCategory.others,
      };
}

enum Severity { low, medium, high }

/// Tracks which app contributed a heat point so the UI can show source badges.
enum HeatSource {
  ngoData,         // from issue_records (uploaded by NGO / partner app)
  volunteerReport, // from reports (submitted by volunteer app)
}

// ── NgoStats ──────────────────────────────────────────────────────────────────

class NgoStats {
  final int totalReports;
  final int totalCampaigns;
  final int totalVolunteers;
  final int impactScore;
  final int prevMonthReports;
  final int prevMonthCampaigns;
  final int prevMonthVolunteers;
  final int prevMonthImpactScore;

  const NgoStats({
    required this.totalReports,
    required this.totalCampaigns,
    required this.totalVolunteers,
    required this.impactScore,
    required this.prevMonthReports,
    required this.prevMonthCampaigns,
    required this.prevMonthVolunteers,
    required this.prevMonthImpactScore,
  });

  factory NgoStats.empty() => const NgoStats(
        totalReports: 0, totalCampaigns: 0,
        totalVolunteers: 0, impactScore: 0,
        prevMonthReports: 0, prevMonthCampaigns: 0,
        prevMonthVolunteers: 0, prevMonthImpactScore: 0,
      );

  factory NgoStats.fromMap(Map<String, dynamic> map) => NgoStats(
        totalReports:          map['totalReports']          ?? 0,
        totalCampaigns:        map['totalCampaigns']        ?? 0,
        totalVolunteers:       map['totalVolunteers']       ?? 0,
        impactScore:           map['impactScore']           ?? 0,
        prevMonthReports:      map['prevMonthReports']      ?? 0,
        prevMonthCampaigns:    map['prevMonthCampaigns']    ?? 0,
        prevMonthVolunteers:   map['prevMonthVolunteers']   ?? 0,
        prevMonthImpactScore:  map['prevMonthImpactScore']  ?? 0,
      );

  factory NgoStats.fromDoc(DocumentSnapshot doc) =>
      NgoStats.fromMap(doc.data() as Map<String, dynamic>? ?? {});

  double get campaignChange  => _pct(totalCampaigns,  prevMonthCampaigns);
  double get volunteerChange => _pct(totalVolunteers,  prevMonthVolunteers);
  double get reportChange    => _pct(totalReports,     prevMonthReports);
  double get impactChange    => _pct(impactScore,      prevMonthImpactScore);

  double _pct(int current, int prev) {
    if (prev == 0) return 0;
    return ((current - prev) / prev) * 100;
  }
}

// ── TrendPoint ────────────────────────────────────────────────────────────────

class TrendPoint {
  final String month;
  final String label;
  final int count;
  const TrendPoint({required this.month, required this.label, required this.count});
}

// ── CategorySplit ─────────────────────────────────────────────────────────────

class CategorySplit {
  final IssueCategory category;
  final int count;
  final double percentage;
  const CategorySplit({required this.category, required this.count, required this.percentage});
}

// ── HeatPoint — now carries source info ───────────────────────────────────────

class HeatPoint {
  final double latitude;
  final double longitude;
  final String locationName;
  final Severity severity;
  final int count;

  /// Which apps contributed data to this point.
  /// A point may have both sources if volunteers AND NGO reported the same area.
  final Set<HeatSource> sources;

  const HeatPoint({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.severity,
    required this.count,
    this.sources = const {HeatSource.ngoData},
  });

  factory HeatPoint.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return HeatPoint(
      latitude:     (d['latitude']  as num).toDouble(),
      longitude:    (d['longitude'] as num).toDouble(),
      locationName: d['locationName'] ?? '',
      severity:     Severity.values.byName(d['severity'] ?? 'low'),
      count:        d['count'] ?? 1,
      sources:      const {HeatSource.ngoData},
    );
  }

  bool get hasNgoData         => sources.contains(HeatSource.ngoData);
  bool get hasVolunteerReport => sources.contains(HeatSource.volunteerReport);
  bool get hasBothSources     => hasNgoData && hasVolunteerReport;
}

// ── Campaign ──────────────────────────────────────────────────────────────────

class Campaign {
  final String id;
  final String title;
  final String location;
  final double latitude;
  final double longitude;
  final IssueCategory category;
  final String status;
  final DateTime startDate;
  final int volunteerGoal;
  final int volunteerCount;
  final String? imageUrl;

  const Campaign({
    required this.id,
    required this.title,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.status,
    required this.startDate,
    required this.volunteerGoal,
    required this.volunteerCount,
    this.imageUrl,
  });

  double get goalPercent =>
      volunteerGoal == 0 ? 0 : (volunteerCount / volunteerGoal).clamp(0, 1);

  factory Campaign.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Campaign(
      id:             doc.id,
      title:          d['title']    ?? '',
      location:       d['location'] ?? '',
      latitude:       (d['latitude']  as num?)?.toDouble() ?? 0,
      longitude:      (d['longitude'] as num?)?.toDouble() ?? 0,
      category:       IssueCategory.fromString(d['category'] ?? ''),
      status:         d['status']   ?? 'upcoming',
      startDate:      (d['startDate'] as Timestamp).toDate(),
      volunteerGoal:  d['volunteerGoal']  ?? 0,
      volunteerCount: d['volunteerCount'] ?? 0,
      imageUrl:       d['imageUrl'],
    );
  }
}

// ── RecentActivity ────────────────────────────────────────────────────────────

class RecentActivity {
  final String fileName;
  final String fileType;
  final DateTime uploadedAt;
  final int recordCount;

  const RecentActivity({
    required this.fileName,
    required this.fileType,
    required this.uploadedAt,
    required this.recordCount,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(uploadedAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  factory RecentActivity.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return RecentActivity(
      fileName:    d['fileName']    ?? 'Unnamed file',
      fileType:    d['fileType']    ?? 'csv',
      uploadedAt:  (d['uploadedAt'] as Timestamp).toDate(),
      recordCount: d['recordCount'] ?? 0,
    );
  }
}