// apps/setu_ngo/lib/features/dashboard/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';
import '../core/providers/dashboard_provider.dart';
import '../presentation/dashboard/dashboard_widgets.dart';
=======
import 'package:setu_ngo/features/campaigns/screens/campaign_list.dart';
import 'dart:math' as math;
import '../../forms/screens/forms_list.dart';
import 'package:setu_ngo/features/data/screens/data_screen.dart';
>>>>>>> f1522c9 (upload screen+  firebase + analytics)

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data on first mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().load();
    });
  }
<<<<<<< HEAD
=======
}

// ─── Main Scaffold with Bottom Navigation ────────────────────────────────────

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    CampaignsPage(),
    DataScreen(),
    FormsListScreen(),
    ProfilePage(),
  ];
>>>>>>> f1522c9 (upload screen+  firebase + analytics)

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: switch (provider.status) {
          DashboardStatus.loading || DashboardStatus.initial => const _LoadingView(),
          DashboardStatus.error   => _ErrorView(message: provider.errorMessage ?? 'Something went wrong',
              onRetry: () => provider.refresh()),
          DashboardStatus.loaded  => _DashboardBody(provider: provider),
        },
      ),
    );
  }
}

// ── Main scrollable body ──────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final DashboardProvider provider;
  const _DashboardBody({required this.provider});

  @override
  Widget build(BuildContext context) {
    final stats = provider.stats;

    return RefreshIndicator(
      color: kPrimary,
      onRefresh: provider.refresh,
      child: CustomScrollView(
        slivers: [

          // ── App bar ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _AppBar(ngoName: provider.ngoName)),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(delegate: SliverChildListDelegate([

              // ── Stat cards (2×2 grid) ────────────────────────────────────
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.45,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    icon: Icons.campaign_rounded,
                    iconBg: kPrimaryBg,
                    iconColor: kPrimary,
                    label: 'Campaigns',
                    value: stats.totalCampaigns.toString(),
                    changePercent: stats.campaignChange,
                  ),
                  StatCard(
                    icon: Icons.group_rounded,
                    iconBg: const Color(0xFFE6F9F0),
                    iconColor: kGreen,
                    label: 'Volunteers',
                    value: stats.totalVolunteers.toString(),
                    changePercent: stats.volunteerChange,
                  ),
                  StatCard(
                    icon: Icons.bar_chart_rounded,
                    iconBg: const Color(0xFFFFF3E2),
                    iconColor: kOrange,
                    label: 'Reports',
                    value: stats.totalReports.toString(),
                    changePercent: stats.reportChange,
                  ),
                  StatCard(
                    icon: Icons.favorite_rounded,
                    iconBg: const Color(0xFFFFEBEE),
                    iconColor: kRed,
                    label: 'Impact Score',
                    value: '${stats.impactScore}/100',
                    changePercent: stats.impactChange,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Trend line chart ─────────────────────────────────────────
              TrendLineChart(
                points: provider.trend,
                totalParticipants: provider.trend.fold(0, (s, p) => s + p.count),
                changePercent: stats.reportChange,
              ),
              const SizedBox(height: 12),

              // ── Donut chart ──────────────────────────────────────────────
              DonutChart(categories: provider.categories),
              const SizedBox(height: 12),

              // ── Top performing campaign ───────────────────────────────────
              if (provider.topCampaign != null) ...[
                TopCampaignCard(campaign: provider.topCampaign!),
                const SizedBox(height: 20),
              ],

              // ── Quick Actions ────────────────────────────────────────────
              const SectionTitle(title: 'Quick Actions'),
              const SizedBox(height: 12),
              _QuickActions(),
              const SizedBox(height: 20),

              // ── Impact Heatmap + Recent Activity (side by side on large) ─
              const SectionTitle(title: 'Impact Heatmap', action: 'View Map'),
              const SizedBox(height: 12),
              IssueHeatmap(points: provider.heatPoints),
              const SizedBox(height: 20),

              // ── Recent Activity ───────────────────────────────────────────
              SectionTitle(title: 'Recent Activity', action: 'View All', onAction: () {}),
              const SizedBox(height: 12),
              if (provider.recentActivity.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No uploads yet',
                    style: TextStyle(color: kTextGrey, fontSize: 13))),
                )
              else
                ...provider.recentActivity.map((a) => ActivityTile(activity: a)),
              const SizedBox(height: 20),

              // ── Upcoming Campaigns ────────────────────────────────────────
              SectionTitle(title: 'Upcoming Campaigns', action: 'View All', onAction: () {}),
              const SizedBox(height: 12),
              if (provider.upcomingCampaigns.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No upcoming campaigns',
                    style: TextStyle(color: kTextGrey, fontSize: 13))),
                )
              else
                ...provider.upcomingCampaigns.map((c) => CampaignTile(campaign: c)),

              const SizedBox(height: 32),
            ])),
          ),
        ],
      ),
    );
  }
}

// ── App Bar ───────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  final String ngoName;
  const _AppBar({required this.ngoName});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(children: [
      IconButton(
        icon: const Icon(Icons.menu_rounded, color: kTextDark),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Hello, $ngoName 👋',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kTextDark),
            overflow: TextOverflow.ellipsis),
          const Text("Here's what's happening today",
            style: TextStyle(fontSize: 12, color: kTextGrey)),
        ]),
      ),
      Stack(children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: kTextDark, size: 26),
          onPressed: () {},
        ),
        Positioned(
          top: 8, right: 8,
          child: Container(
            width: 16, height: 16,
            decoration: const BoxDecoration(color: kRed, shape: BoxShape.circle),
            child: const Center(child: Text('3',
              style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700))),
          ),
        ),
      ]),
    ]),
  );
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final _actions = const [
    (icon: Icons.campaign_rounded,     label: 'Create\nCampaign',     color: Color(0xFFEDE9FF), iconColor: kPrimary),
    (icon: Icons.upload_rounded,       label: 'Add Data /\nUpload',   color: Color(0xFFE6F9F0), iconColor: kGreen),
    (icon: Icons.assignment_rounded,   label: 'Create\nForm',         color: Color(0xFFE3F2FD), iconColor: Color(0xFF1976D2)),
    (icon: Icons.bar_chart_rounded,    label: 'View\nAnalytics',      color: Color(0xFFFFF3E2), iconColor: kOrange),
    (icon: Icons.group_add_rounded,    label: 'Invite\nVolunteers',   color: Color(0xFFEDE9FF), iconColor: kPrimary),
    (icon: Icons.description_rounded,  label: 'View\nReports',        color: Color(0xFFFFEBEE), iconColor: kRed),
  ];

  const _QuickActions();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 90,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _actions.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) {
        final a = _actions[i];
        return GestureDetector(
          onTap: () {},
          child: Column(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: a.color, borderRadius: BorderRadius.circular(14)),
              child: Icon(a.icon, color: a.iconColor, size: 26),
            ),
            const SizedBox(height: 6),
            Text(a.label, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: kTextDark, height: 1.3)),
          ]),
        );
      },
    ),
  );
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      CircularProgressIndicator(color: kPrimary, strokeWidth: 2.5),
      SizedBox(height: 16),
      Text('Loading dashboard...', style: TextStyle(color: kTextGrey, fontSize: 13)),
    ]),
  );
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.wifi_off_rounded, color: kTextGrey, size: 48),
        const SizedBox(height: 16),
        Text(message, textAlign: TextAlign.center,
          style: const TextStyle(color: kTextGrey, fontSize: 13)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary, elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      ]),
    ),
  );
}