import 'package:flutter/material.dart';
import 'package:setu_ngo/features/campaigns/screens/campaign_list.dart';
import 'dart:math' as math;
import '../../forms/screens/forms_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Earth Foundation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
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
    DataPage(),
    FormsListScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Dashboard', index: 0, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.campaign_outlined, label: 'Campaigns', index: 1, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.cloud_upload_outlined, label: 'Data', index: 2, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.assignment_outlined, label: 'Forms', index: 3, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
                _NavItem(icon: Icons.person_outline_rounded, label: 'Profile', index: 4, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF6C63FF) : const Color(0xFFADB5BD),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? const Color(0xFF6C63FF) : const Color(0xFFADB5BD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dashboard Page ───────────────────────────────────────────────────────────

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.menu_rounded, size: 24, color: Color(0xFF333333)),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, Green Earth Foundation 👋',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
                        ),
                        Text(
                          "Here's what's happening today",
                          style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, size: 26, color: Color(0xFF333333)),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(color: Color(0xFFFF4757), shape: BoxShape.circle),
                          child: const Center(
                            child: Text('3', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stat Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: const [
                  _StatCard(icon: Icons.campaign_rounded, iconBg: Color(0xFFEDE9FF), iconColor: Color(0xFF6C63FF), title: 'Campaigns', value: '24', change: '↑ 20%', changeLabel: 'vs last month'),
                  _StatCard(icon: Icons.people_alt_rounded, iconBg: Color(0xFFE6F9F1), iconColor: Color(0xFF2ECC71), title: 'Volunteers', value: '248', change: '↑ 18%', changeLabel: 'vs last month'),
                  _StatCard(icon: Icons.description_rounded, iconBg: Color(0xFFFFF3E8), iconColor: Color(0xFFFF8C00), title: 'Reports', value: '1,245', change: '↑ 25%', changeLabel: 'vs last month'),
                  _StatCard(icon: Icons.favorite_rounded, iconBg: Color(0xFFFFE8F3), iconColor: Color(0xFFE91E8C), title: 'Impact Score', value: '87/100', change: '↑ 15%', changeLabel: 'vs last month'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Campaign Participation + Issue Trends row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign chart
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: Text('Campaign\nParticipation',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF1A1A2E))),
                              ),
                              _MonthDropdown(),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text('Total Participants', style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
                          const Text('1,865', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
                          const Row(
                            children: [
                              Icon(Icons.arrow_upward_rounded, size: 12, color: Color(0xFF2ECC71)),
                              Flexible(child: Text(' 12% from last month', style: TextStyle(fontSize: 10, color: Color(0xFF2ECC71)))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(height: 80, child: CustomPaint(painter: _LineChartPainter(), size: Size.infinite)),
                          const SizedBox(height: 6),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('25 May', style: TextStyle(fontSize: 8, color: Color(0xFFAAAAAA))),
                              Text('27 May', style: TextStyle(fontSize: 8, color: Color(0xFFAAAAAA))),
                              Text('29 May', style: TextStyle(fontSize: 8, color: Color(0xFFAAAAAA))),
                              Text('31 May', style: TextStyle(fontSize: 8, color: Color(0xFFAAAAAA))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Right column
                  Expanded(
                    child: Column(
                      children: [
                        // Issue Trends
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Issue Trends',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF1A1A2E))),
                                  _MonthDropdown(),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(width: 70, height: 70, child: CustomPaint(painter: _DonutChartPainter())),
                                  const SizedBox(width: 8),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _LegendItem(color: Color(0xFF2ECC71), label: 'Environment', pct: '35%'),
                                      _LegendItem(color: Color(0xFF6C63FF), label: 'Education', pct: '25%'),
                                      _LegendItem(color: Color(0xFFF0B429), label: 'Health', pct: '20%'),
                                      _LegendItem(color: Color(0xFFFF6B9D), label: 'Community', pct: '10%'),
                                      _LegendItem(color: Color(0xFFB0BEC5), label: 'Others', pct: '10%'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Top Performing Campaign
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: _cardDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Top Performing Campaign',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Color(0xFF1A1A2E))),
                              const SizedBox(height: 10),
                              const Text('Beach Cleanup Drive',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF1A1A2E))),
                              const Text('Bali, Indonesia', style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
                              const SizedBox(height: 8),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('82% Goal Achieved', style: TextStyle(fontSize: 10, color: Color(0xFF555555))),
                                  Text('32/50', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: const LinearProgressIndicator(
                                  value: 0.82,
                                  backgroundColor: Color(0xFFEDE9FF),
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                                  minHeight: 6,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text('Volunteers', style: TextStyle(fontSize: 9, color: Color(0xFF888888))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Actions',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickAction(icon: Icons.campaign_rounded, label: 'Create\nCampaign', bg: const Color(0xFFEDE9FF), iconColor: const Color(0xFF6C63FF)),
                      _QuickAction(icon: Icons.cloud_upload_rounded, label: 'Add Data /\nUpload', bg: const Color(0xFFE6F9F1), iconColor: const Color(0xFF2ECC71)),
                      _QuickAction(icon: Icons.assignment_rounded, label: 'Create\nForm', bg: const Color(0xFFE8F4FF), iconColor: const Color(0xFF1E90FF)),
                      _QuickAction(icon: Icons.bar_chart_rounded, label: 'View\nAnalytics', bg: const Color(0xFFFFF3E8), iconColor: const Color(0xFFFF8C00)),
                      _QuickAction(icon: Icons.person_add_rounded, label: 'Invite\nVolunteers', bg: const Color(0xFFEDE9FF), iconColor: const Color(0xFF6C63FF)),
                      _QuickAction(icon: Icons.description_rounded, label: 'View\nReports', bg: const Color(0xFFFFE8F3), iconColor: const Color(0xFFE91E8C)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Impact Heatmap + Recent Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heatmap
                  Expanded(
                    child: Container(
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Impact Heatmap',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                                Text('View Map',
                                    style: TextStyle(fontSize: 11, color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 130,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              child: CustomPaint(painter: _HeatmapPainter(), child: Container()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                            child: Row(
                              children: [
                                const Text('Low Impact', style: TextStyle(fontSize: 9, color: Color(0xFF888888))),
                                Expanded(
                                  child: Container(
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: const LinearGradient(
                                          colors: [Color(0xFFFFF176), Color(0xFFFF5722)]),
                                    ),
                                  ),
                                ),
                                const Text('High Impact', style: TextStyle(fontSize: 9, color: Color(0xFF888888))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Recent Activity
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _cardDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Recent Activity',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                              Text('View All',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                            ],
                          ),
                          SizedBox(height: 10),
                          _ActivityItem(icon: Icons.description_outlined, iconColor: Color(0xFF6C63FF), text: 'New report submitted for Beach Cleanup Drive', time: '2m ago'),
                          _ActivityItem(icon: Icons.water_drop_outlined, iconColor: Color(0xFF1E90FF), text: 'Water Conservation Awareness updated', time: '1h ago'),
                          _ActivityItem(icon: Icons.people_outline, iconColor: Color(0xFF2ECC71), text: '45 new volunteers joined your org', time: '3h ago'),
                          _ActivityItem(icon: Icons.eco_outlined, iconColor: Color(0xFF2ECC71), text: 'Tree Plantation Program completed', time: '1d ago'),
                          _ActivityItem(icon: Icons.upload_file_outlined, iconColor: Color(0xFF6C63FF), text: 'Waste Collection Report uploaded', time: '2d ago'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Upcoming Campaigns
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Upcoming Campaigns',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1A1A2E))),
                  Text('View All',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6C63FF), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const _CampaignCard(
              imageColor: Color(0xFF4FC3F7),
              title: 'Beach Cleanup Drive',
              location: 'Bali, Indonesia',
              date: '25 May 2024 • 08:00 AM',
              volunteers: '32/50',
            ),
            const _CampaignCard(
              imageColor: Color(0xFF81C784),
              title: 'Tree Plantation Program',
              location: 'Bandung, Indonesia',
              date: '10 Jun 2024 • 09:00 AM',
              volunteers: '28/40',
            ),
            const _CampaignCard(
              imageColor: Color(0xFF4DB6AC),
              title: 'Clean Water Awareness',
              location: 'Jakarta, Indonesia',
              date: '5 Apr 2024 • 10:00 AM',
              volunteers: '45/45',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable Widgets ─────────────────────────────────────────────────────────

class _MonthDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This Month', style: TextStyle(fontSize: 9, color: Color(0xFF555555))),
          Icon(Icons.keyboard_arrow_down_rounded, size: 12, color: Color(0xFF555555)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final String change;
  final String changeLabel;

  const _StatCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.change,
    required this.changeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 12, color: Color(0xFF888888)))),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1A2E))),
              Wrap(
                children: [
                  Text(change, style: const TextStyle(fontSize: 10, color: Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
                  const SizedBox(width: 4),
                  Text(changeLabel, style: const TextStyle(fontSize: 10, color: Color(0xFF888888))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String pct;

  const _LegendItem({required this.color, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF444444))),
          const SizedBox(width: 4),
          Text(pct, style: const TextStyle(fontSize: 9, color: Color(0xFF888888))),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color iconColor;

  const _QuickAction({required this.icon, required this.label, required this.bg, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 9, color: Color(0xFF555555))),
      ],
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final String time;

  const _ActivityItem({required this.icon, required this.iconColor, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 10, color: Color(0xFF444444)))),
          const SizedBox(width: 4),
          Text(time, style: const TextStyle(fontSize: 9, color: Color(0xFFAAAAAA))),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final Color imageColor;
  final String title;
  final String location;
  final String date;
  final String volunteers;

  const _CampaignCard({
    required this.imageColor,
    required this.title,
    required this.location,
    required this.date,
    required this.volunteers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(width: 70, height: 70, color: imageColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 11, color: Color(0xFF888888)),
                  const SizedBox(width: 2),
                  Flexible(child: Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFF888888)))),
                ]),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 11, color: Color(0xFF888888)),
                  const SizedBox(width: 2),
                  Flexible(child: Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF888888)))),
                ]),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFE8FFF3), borderRadius: BorderRadius.circular(20)),
                child: const Text('Upcoming',
                    style: TextStyle(fontSize: 9, color: Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
              Text(volunteers,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF1A1A2E))),
              const Text('Volunteers', style: TextStyle(fontSize: 9, color: Color(0xFF888888))),
              const SizedBox(height: 4),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFCCCCCC)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Placeholder Pages ────────────────────────────────────────────────────────





class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CampaignListScreen();
  }
}

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Data Page"),
      ),
    );
  }
}
class FormsPage extends StatelessWidget {
  const FormsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Data")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FormsListScreen(),
              ),
            );
          },
          child: Text("Go to Forms"),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _PlaceholderPage(title: 'Profile', icon: Icons.person_rounded, color: Color(0xFFE91E8C));
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _PlaceholderPage({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, color: color, size: 40),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 8),
              const Text('This page is coming soon',
                  style: TextStyle(fontSize: 14, color: Color(0xFF888888))),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2)),
      ],
    );

// ─── Custom Painters ──────────────────────────────────────────────────────────

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final points = [0.7, 0.5, 0.55, 0.6, 0.58, 0.65, 1.0];
    final dx = size.width / (points.length - 1);

    // Fill
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (int i = 0; i < points.length; i++) {
      fillPath.lineTo(i * dx, size.height * (1 - points[i]));
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.3),
            const Color(0xFF6C63FF).withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      final x = i * dx;
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF6C63FF)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots
    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(
        Offset(i * dx, size.height * (1 - points[i])),
        3,
        Paint()..color = const Color(0xFF6C63FF),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 14.0;

    final segments = [
      (0.35, const Color(0xFF2ECC71)),
      (0.25, const Color(0xFF6C63FF)),
      (0.20, const Color(0xFFF0B429)),
      (0.10, const Color(0xFFFF6B9D)),
      (0.10, const Color(0xFFB0BEC5)),
    ];

    double startAngle = -math.pi / 2;
    for (final seg in segments) {
      final sweepAngle = seg.$1 * 2 * math.pi;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle - 0.04,
        false,
        Paint()
          ..color = seg.$2
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeatmapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE8ECF0),
    );

    // Grid lines
    final linePaint = Paint()
      ..color = const Color(0xFFD0D5DD)
      ..strokeWidth = 0.5;
    for (double x = 20; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = 20; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Heat blobs
    _drawHeatBlob(canvas, Offset(size.width * 0.45, size.height * 0.38), 34, const Color(0xFFFF5722));
    _drawHeatBlob(canvas, Offset(size.width * 0.67, size.height * 0.65), 26, const Color(0xFFFF8C00));
    _drawHeatBlob(canvas, Offset(size.width * 0.28, size.height * 0.52), 20, const Color(0xFFFFC107));
    _drawHeatBlob(canvas, Offset(size.width * 0.55, size.height * 0.22), 16, const Color(0xFF4CAF50));

    // Labels
    _drawLabel(canvas, 'North Jakarta', Offset(size.width * 0.28, size.height * 0.08));
    _drawLabel(canvas, 'West Jakarta', Offset(size.width * 0.04, size.height * 0.44));
    _drawLabel(canvas, 'Central Jakarta', Offset(size.width * 0.33, size.height * 0.55));
    _drawLabel(canvas, 'East Jakarta', Offset(size.width * 0.55, size.height * 0.50));
    _drawLabel(canvas, 'South Jakarta', Offset(size.width * 0.28, size.height * 0.78));
    _drawLabel(canvas, 'Bekasi', Offset(size.width * 0.72, size.height * 0.62));
  }

  void _drawHeatBlob(Canvas canvas, Offset center, double radius, Color color) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withOpacity(0.75), color.withOpacity(0.0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: Color(0xFF555555), fontSize: 8)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}