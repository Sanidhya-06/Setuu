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
  final String imageUrl;
  final String badge;
  final Color badgeColor;
  final int joinedCount;
  final List<String> volunteerAvatars;
  final String category;

  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.state,
    required this.date,
    required this.imageUrl,
    required this.badge,
    required this.badgeColor,
    required this.joinedCount,
    required this.volunteerAvatars,
    required this.category,
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
      imageUrl: data['imageUrl'] ?? '',
      badge: data['badge'] ?? '',
      badgeColor: _parseColor(data['badgeColor']),
      joinedCount: data['joinedCount'] ?? 0,
      volunteerAvatars: List<String>.from(data['volunteerAvatars'] ?? []),
      category: data['category'] ?? '',
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null) return const Color(0xFF5A4EFF);
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF5A4EFF);
  }
}

class UpcomingEvent {
  final String id;
  final String title;
  final String description;
  final String location;
  final String timeRange;
  final String imageUrl;
  final String month;
  final String day;

  const UpcomingEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.timeRange,
    required this.imageUrl,
    required this.month,
    required this.day,
  });

  factory UpcomingEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UpcomingEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      timeRange: data['timeRange'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      month: data['month'] ?? '',
      day: data['day'] ?? '',
    );
  }
}

class StateItem {
  final String name;
  final String imageUrl;
  final Color borderColor;

  const StateItem({
    required this.name,
    required this.imageUrl,
    required this.borderColor,
  });

  factory StateItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StateItem(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      borderColor: Campaign._parseColor(data['borderColor']),
    );
  }
}

// ── Controller ────────────────────────────────────────────────────────────────

class DiscoverController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // State
  String _selectedState = 'All';
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final Set<String> _savedCampaigns = {};

  bool _loadingCampaigns = false;
  bool _loadingEvents = false;
  bool _loadingStates = false;

  String? _campaignsError;
  String? _eventsError;

  List<Campaign> _campaigns = [];
  List<UpcomingEvent> _events = [];
  List<StateItem> _states = [];

  // Getters
  String get selectedState => _selectedState;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  bool get loadingCampaigns => _loadingCampaigns;
  bool get loadingEvents => _loadingEvents;
  bool get loadingStates => _loadingStates;
  String? get campaignsError => _campaignsError;
  String? get eventsError => _eventsError;
  List<StateItem> get states => _states;
  List<UpcomingEvent> get events => _events;
  bool isSaved(String id) => _savedCampaigns.contains(id);

  final List<String> filterChips = [
    'All',
    'Education',
    'Environment',
    'Health',
    'Community',
    'Disaster Relief',
  ];

  List<Campaign> get filteredCampaigns {
    return _campaigns.where((c) {
      final matchesFilter =
          _selectedFilter == 'All' || c.category == _selectedFilter;
      final matchesState =
          _selectedState == 'All' || c.state == _selectedState;
      final matchesSearch = _searchQuery.isEmpty ||
          c.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesState && matchesSearch;
    }).toList();
  }

  // ── Firebase Fetchers ──────────────────────────────────────────────────────

  Future<void> fetchCampaigns() async {
    _loadingCampaigns = true;
    _campaignsError = null;
    notifyListeners();

    try {
      final snap = await _db
          .collection('campaigns')
          .orderBy('joinedCount', descending: true)
          .get();
      _campaigns = snap.docs.map((d) => Campaign.fromFirestore(d)).toList();
    } catch (e) {
      _campaignsError = 'Failed to load campaigns. Please try again.';
    } finally {
      _loadingCampaigns = false;
      notifyListeners();
    }
  }

  Future<void> fetchEvents() async {
    _loadingEvents = true;
    _eventsError = null;
    notifyListeners();

    try {
      final snap = await _db
          .collection('events')
          .orderBy('date')
          .limit(10)
          .get();
      _events = snap.docs.map((d) => UpcomingEvent.fromFirestore(d)).toList();
    } catch (e) {
      _eventsError = 'Failed to load events.';
    } finally {
      _loadingEvents = false;
      notifyListeners();
    }
  }

  Future<void> fetchStates() async {
    _loadingStates = true;
    notifyListeners();

    try {
      final snap = await _db.collection('states').get();
      _states = snap.docs.map((d) => StateItem.fromFirestore(d)).toList();
    } catch (e) {
      // silently fail, show empty
    } finally {
      _loadingStates = false;
      notifyListeners();
    }
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchCampaigns(), fetchEvents(), fetchStates()]);
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setState_(String state) {
    _selectedState = state;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSave(String id) {
    if (_savedCampaigns.contains(id)) {
      _savedCampaigns.remove(id);
    } else {
      _savedCampaigns.add(id);
    }
    notifyListeners();
  }

  Future<void> saveEventToFirestore(String eventId) async {
    try {
      await _db.collection('savedEvents').add({
        'eventId': eventId,
        'savedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}