import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dashboard_models.dart';
import '../repository/dashboard_repository.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repo = DashboardRepository();

  DashboardStatus status = DashboardStatus.initial;
  String? errorMessage;

  // ── Real-time subscription ─────────────────────────────────────────────
  StreamSubscription? _statsSub;

  // ── Data fields ────────────────────────────────────────────────────────
  String ngoName = '';
  NgoStats stats = NgoStats.empty();
  List<TrendPoint> trend = [];
  List<CategorySplit> categories = [];
  List<HeatPoint> heatPoints = [];
  Campaign? topCampaign;
  List<Campaign> upcomingCampaigns = [];
  List<RecentActivity> recentActivity = [];

  // ── Load dashboard data ────────────────────────────────────────────────
  Future<void> load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      errorMessage = 'Not logged in.';
      status = DashboardStatus.error;
      notifyListeners();
      return;
    }

    status = DashboardStatus.loading;
    notifyListeners();

    try {
      // ── Setup real-time listener for stats ─────────────────────────────
      _statsSub?.cancel();

      _statsSub = FirebaseFirestore.instance
          .collection('ngo_stats')
          .doc(uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          stats = NgoStats.fromMap(doc.data()!);
          notifyListeners();
        }
      });

      // ── Fetch remaining data in parallel (excluding stats) ─────────────
      final results = await Future.wait([
        _repo.fetchNgoName(uid),           // 0
        _repo.fetchTrend(uid),             // 1
        _repo.fetchCategorySplit(uid),     // 2
        _repo.fetchHeatPoints(uid),        // 3
        _repo.fetchTopCampaign(uid),       // 4
        _repo.fetchUpcomingCampaigns(uid), // 5
        _repo.fetchRecentActivity(uid),    // 6
      ]);

      ngoName = results[0] as String;
      trend = results[1] as List<TrendPoint>;
      categories = results[2] as List<CategorySplit>;
      heatPoints = results[3] as List<HeatPoint>;
      topCampaign = results[4] as Campaign?;
      upcomingCampaigns = results[5] as List<Campaign>;
      recentActivity = results[6] as List<RecentActivity>;

      status = DashboardStatus.loaded;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
      status = DashboardStatus.error;
    }

    notifyListeners();
  }

  Future<void> refresh() => load();

  // ── Dispose ───────────────────────────────────────────────────────────
  @override
  void dispose() {
    _statsSub?.cancel();
    super.dispose();
  }
}