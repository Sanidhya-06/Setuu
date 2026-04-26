import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class HeatmapUser {
  final String uid;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final List<String> interests;

  const HeatmapUser({
    required this.uid,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.interests,
  });

  factory HeatmapUser.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return HeatmapUser(
      uid: d['uid'] ?? doc.id,
      name: d['name'] ?? '',
      location: d['location'] ?? '',
      latitude: (d['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (d['longitude'] as num?)?.toDouble() ?? 0.0,
      interests: List<String>.from(d['interests'] ?? []),
    );
  }

  LatLng get latLng => LatLng(latitude, longitude);
}

class IssueReport {
  final String id;
  final String issueType;
  final String location;
  final String description;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime? createdAt;

  const IssueReport({
    required this.id,
    required this.issueType,
    required this.location,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.status,
    this.createdAt,
  });

  factory IssueReport.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return IssueReport(
      id: doc.id,
      issueType: d['issueType'] ?? '',
      location: d['location'] ?? '',
      description: d['description'] ?? '',
      latitude: (d['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (d['longitude'] as num?)?.toDouble() ?? 0.0,
      status: d['status'] ?? 'pending',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  LatLng get latLng => LatLng(latitude, longitude);

  Color get statusColor {
    switch (status) {
      case 'resolved':
        return const Color(0xFF2E7D32);
      case 'in_progress':
        return const Color(0xFFFF8F00);
      default:
        return const Color(0xFFE53935);
    }
  }

  IconData get issueIcon {
    switch (issueType) {
      case 'Environment':
        return Icons.eco_rounded;
      case 'Education':
        return Icons.school_rounded;
      case 'Health':
        return Icons.favorite_rounded;
      case 'Animal Welfare':
        return Icons.pets_rounded;
      case 'Disaster Relief':
        return Icons.shield_rounded;
      case 'Community':
        return Icons.group_rounded;
      default:
        return Icons.report_problem_rounded;
    }
  }
}

// ── Map Mode ──────────────────────────────────────────────────────────────────

enum MapMode { volunteers, issues }

// ── Controller ────────────────────────────────────────────────────────────────

class HeatmapController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<HeatmapUser> _users = [];
  List<IssueReport> _issues = [];

  bool _loadingUsers = false;
  bool _loadingIssues = false;
  String? _error;

  MapMode _mode = MapMode.volunteers;
  String _currentUserUid = '';
  HeatmapUser? _selectedUser;
  IssueReport? _selectedIssue;

  // Getters
  List<HeatmapUser> get users => _users;
  List<IssueReport> get issues => _issues;
  bool get isLoading => _loadingUsers || _loadingIssues;
  String? get error => _error;
  MapMode get mode => _mode;
  HeatmapUser? get selectedUser => _selectedUser;
  IssueReport? get selectedIssue => _selectedIssue;
  String get currentUserUid => _currentUserUid;

  // ── Init ───────────────────────────────────────────────────────────────────

  void init(String currentUserUid) {
    _currentUserUid = currentUserUid;
    fetchAll();
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchUsers(), fetchIssues()]);
  }

  // ── Fetch Users ────────────────────────────────────────────────────────────

  Future<void> fetchUsers() async {
    _loadingUsers = true;
    _error = null;
    notifyListeners();
    try {
      final snap = await _db.collection('users').get();
      _users = snap.docs
          .map((d) => HeatmapUser.fromFirestore(d))
          .where((u) => u.latitude != 0.0 && u.longitude != 0.0)
          .toList();
    } catch (e) {
      _error = 'Failed to load volunteer locations.';
    } finally {
      _loadingUsers = false;
      notifyListeners();
    }
  }

  // ── Fetch Issues ───────────────────────────────────────────────────────────

  Future<void> fetchIssues() async {
    _loadingIssues = true;
    notifyListeners();
    try {
      final snap = await _db.collection('reports').get();
      _issues = snap.docs
          .map((d) => IssueReport.fromFirestore(d))
          .where((r) => r.latitude != 0.0 && r.longitude != 0.0)
          .toList();
    } catch (e) {
      // silent fail
    } finally {
      _loadingIssues = false;
      notifyListeners();
    }
  }

  // ── Mode Switch ────────────────────────────────────────────────────────────

  void setMode(MapMode mode) {
    _mode = mode;
    _selectedUser = null;
    _selectedIssue = null;
    notifyListeners();
  }

  // ── Selection ──────────────────────────────────────────────────────────────

  void selectUser(HeatmapUser user) {
    _selectedUser = user;
    _selectedIssue = null;
    notifyListeners();
  }

  void selectIssue(IssueReport issue) {
    _selectedIssue = issue;
    _selectedUser = null;
    notifyListeners();
  }

  void clearSelection() {
    _selectedUser = null;
    _selectedIssue = null;
    notifyListeners();
  }
}