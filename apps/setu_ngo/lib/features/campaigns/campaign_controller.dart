import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ── Data Models ───────────────────────────────────────────────────────────────

class Campaign {
  final String id;
  final String title;
  final String description;
  final String location;
  final String state;
  final String date;
  final String time;
  final String imageUrl;
  final String badge; // 'Active' | 'Upcoming' | 'Completed'
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
      case 'Upcoming':
        return const Color(0xFF5A4EFF);
      case 'Completed':
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFF5A4EFF);
    }
  }

  Campaign copyWith({
    String? badge,
    Color? badgeColor,
    int? joinedCount,
    int? maxVolunteers,
  }) {
    return Campaign(
      id: id,
      title: title,
      description: description,
      location: location,
      state: state,
      date: date,
      time: time,
      imageUrl: imageUrl,
      badge: badge ?? this.badge,
      badgeColor: badgeColor ?? this.badgeColor,
      joinedCount: joinedCount ?? this.joinedCount,
      maxVolunteers: maxVolunteers ?? this.maxVolunteers,
      volunteerAvatars: volunteerAvatars,
      category: category,
      organizerId: organizerId,
    );
  }
}

// ── Controller ────────────────────────────────────────────────────────────────

class CampaignController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // State
  String _selectedTab = 'All Campaigns'; // All Campaigns | Active | Upcoming | Completed
  String _searchQuery = '';
  bool _loading = false;
  String? _error;
  List<Campaign> _campaigns = [];
  int _notificationCount = 3;

  // Getters
  String get selectedTab => _selectedTab;
  String get searchQuery => _searchQuery;
  bool get loading => _loading;
  String? get error => _error;
  int get notificationCount => _notificationCount;

  final List<String> tabs = [
    'All Campaigns',
    'Active',
    'Upcoming',
    'Completed',
  ];

  List<Campaign> get filteredCampaigns {
    return _campaigns.where((c) {
      final matchesTab = _selectedTab == 'All Campaigns' || c.badge == _selectedTab;
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesTab && matchesSearch;
    }).toList();
  }

  int get totalCampaigns => _campaigns.length;

  // ── Firebase ──────────────────────────────────────────────────────────────

  Future<void> fetchCampaigns() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final snap = await _db
          .collection('campaigns')
          .orderBy('createdAt', descending: true)
          .get();
      _campaigns = snap.docs.map((d) => Campaign.fromFirestore(d)).toList();
    } catch (e) {
      _error = 'Failed to load campaigns. Please try again.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createCampaign(Campaign campaign) async {
    try {
      await _db.collection('campaigns').add(campaign.toFirestore());
      await fetchCampaigns();
      return true;
    } catch (e) {
      return false;
    }
  }

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
      final idx = _campaigns.indexWhere((c) => c.id == id);
      if (idx != -1) {
        _campaigns[idx] = _campaigns[idx].copyWith(
          badge: newStatus,
          badgeColor: Campaign.badgeColorForStatus(newStatus),
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCampaign(String id) async {
    try {
      await _db.collection('campaigns').doc(id).delete();
      _campaigns.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

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