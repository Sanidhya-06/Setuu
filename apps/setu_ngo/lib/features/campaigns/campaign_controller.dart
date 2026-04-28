import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/ngo_stats_service.dart';

// ── Data Model ───────────────────────────────────────────────────────────────

class Campaign {
  final String id;
  final String title;
  final String description;
  final String location;
  final String state;
  final String date;
  final String time;
  final String imageUrl;
  final String badge;
  final Color badgeColor;
  final int joinedCount;
  final int maxVolunteers;
  final List<String> volunteerAvatars;
  final String category;
  final String organizerId;

  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.state,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.badge,
    required this.badgeColor,
    required this.joinedCount,
    required this.maxVolunteers,
    required this.volunteerAvatars,
    required this.category,
    required this.organizerId,
  });

  factory Campaign.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Campaign(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      state: data['state'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      badge: data['badge'] ?? 'Upcoming',
      badgeColor: _parseColor(data['badgeColor']),
      joinedCount: data['joinedCount'] ?? 0,
      maxVolunteers: data['maxVolunteers'] ?? 50,
      volunteerAvatars: List<String>.from(data['volunteerAvatars'] ?? []),
      category: data['category'] ?? '',
      organizerId: data['organizerId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'state': state,
      'date': date,
      'time': time,
      'imageUrl': imageUrl,
      'badge': badge,
      'badgeColor': '#5A4EFF',
      'joinedCount': joinedCount,
      'maxVolunteers': maxVolunteers,
      'volunteerAvatars': volunteerAvatars,
      'category': category,
      'organizerId': organizerId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  static Color _parseColor(dynamic hex) {
    if (hex == null) return const Color(0xFF5A4EFF);
    final str = hex.toString();
    final buffer = StringBuffer();
    if (str.length == 6 || str.length == 7) buffer.write('ff');
    buffer.write(str.replaceFirst('#', ''));
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF5A4EFF);
  }

  static Color badgeColorForStatus(String status) {
    switch (status) {
      case 'Active':
        return const Color(0xFF22C55E);
      case 'Completed':
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF5A4EFF);
    }
  }
}

// ── Controller ───────────────────────────────────────────────────────────────

class CampaignController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── UI STATE ──────────────────────────────────────────────────────────────

  String _selectedTab = 'All Campaigns';
  String _searchQuery = '';
  int _notificationCount = 3;

  final List<String> tabs = [
    'All Campaigns',
    'Active',
    'Upcoming',
    'Completed',
  ];

  String get selectedTab => _selectedTab;
  String get searchQuery => _searchQuery;
  int get notificationCount => _notificationCount;

  // ── DATA STATE ────────────────────────────────────────────────────────────

  List<Campaign> _campaigns = [];
  bool _loading = false;
  String? _error;

  List<Campaign> get campaigns => _campaigns;
  bool get loading => _loading;
  String? get error => _error;

  // ── FILTERED LIST ─────────────────────────────────────────────────────────

  List<Campaign> get filteredCampaigns {
    return _campaigns.where((c) {
      final matchesTab =
          _selectedTab == 'All Campaigns' || c.badge == _selectedTab;

      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesTab && matchesSearch;
    }).toList();
  }

  // ── FETCH ─────────────────────────────────────────────────────────────────

  Future<void> fetchCampaigns() async {
    _loading = true;
    notifyListeners();

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snap = await _db
          .collection('campaigns')
          .where('organizerId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      _campaigns = snap.docs.map((d) => Campaign.fromFirestore(d)).toList();
      _error = null;
    } catch (e) {
      _error = 'Failed to load campaigns';
      // ⚠️ If you see a "requires index" error in console, go to:
      // Firebase Console → Firestore → Indexes → create composite index:
      //   Collection: campaigns
      //   Fields: organizerId (Ascending), createdAt (Descending)
      debugPrint('fetchCampaigns error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ── CREATE ────────────────────────────────────────────────────────────────

  Future<bool> createCampaign(Campaign campaign) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // ✅ Step 1: Save to Firestore — this is the critical operation
      await _db.collection('campaigns').add({
        ...campaign.toFirestore(),
        'organizerId': uid,
      });

      // ✅ Step 2: Update stats — failure here won't affect creation result
      try {
        await NgoStatsService().updateStats(uid);
      } catch (e) {
        debugPrint('Stats update error (non-fatal): $e');
      }

      // ✅ Step 3: Refresh list — failure here (e.g. missing index) won't
      // affect creation result. List refreshes on next screen load.
      try {
        await fetchCampaigns();
      } catch (e) {
        debugPrint('fetchCampaigns after create error (non-fatal): $e');
      }

      return true; // ✅ True as long as the add() above succeeded

    } catch (e) {
      debugPrint('createCampaign error: $e');
      return false;
    }
  }

  // ── UPDATE STATUS ─────────────────────────────────────────────────────────

  Future<bool> updateCampaignStatus(String id, String newStatus) async {
    try {
      await _db.collection('campaigns').doc(id).update({
        'badge': newStatus,
        'badgeColor': newStatus == 'Active'
            ? '#22C55E'
            : newStatus == 'Completed'
                ? '#9CA3AF'
                : '#5A4EFF',
      });

      final uid = FirebaseAuth.instance.currentUser!.uid;

      try {
        await NgoStatsService().updateStats(uid);
      } catch (e) {
        debugPrint('Stats update error (non-fatal): $e');
      }

      try {
        await fetchCampaigns();
      } catch (e) {
        debugPrint('fetchCampaigns after update error (non-fatal): $e');
      }

      return true;
    } catch (e) {
      debugPrint('updateCampaignStatus error: $e');
      return false;
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────────────

  Future<bool> deleteCampaign(String id) async {
    try {
      await _db.collection('campaigns').doc(id).delete();

      final uid = FirebaseAuth.instance.currentUser!.uid;

      try {
        await NgoStatsService().updateStats(uid);
      } catch (e) {
        debugPrint('Stats update error (non-fatal): $e');
      }

      try {
        await fetchCampaigns();
      } catch (e) {
        debugPrint('fetchCampaigns after delete error (non-fatal): $e');
      }

      return true;
    } catch (e) {
      debugPrint('deleteCampaign error: $e');
      return false;
    }
  }

  // ── UI ACTIONS ────────────────────────────────────────────────────────────

  void setTab(String tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }
}