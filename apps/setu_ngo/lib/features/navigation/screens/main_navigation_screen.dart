// apps/setu_ngo/lib/features/navigation/screens/main_navigation_screen.dart
//
// Drop-in replacement for whatever widget you currently set as `home:` in
// MaterialApp.  It owns the bottom nav bar and swaps screens via IndexedStack
// so each tab keeps its own state (scroll position, loaded data, etc.)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../campaigns/screens/campaign_list.dart';
import '../../data/screens/data_screen.dart';

// ── Import your real screen files here ───────────────────────────────────────
// Replace these placeholder imports with your actual feature screens:
//
// import '../../dashboard/screens/dashboard_screen.dart';
// import '../../campaigns/screens/campaigns_screen.dart';
// import '../../data/screens/data_screen.dart';
// import '../../forms/screens/forms_screen.dart';
 import '../../profile/screens/ngo_profile.dart';

// ── Colour tokens (keep in sync with the rest of your app) ───────────────────
const kPrimary   = Color(0xFF6C5CE7);
const kBg        = Color(0xFFF5F5FA);
const kTextDark  = Color(0xFF1A1A2E);
const kTextGrey  = Color(0xFF9E9E9E);
const kNavBg     = Colors.white;


// ═════════════════════════════════════════════════════════════════════════════
// MainNavigationScreen
// ═════════════════════════════════════════════════════════════════════════════

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;

  // ── Tab config ──────────────────────────────────────────────────────────────
  static const _tabs = [
    _TabItem(icon: Icons.home_rounded,          label: 'Dashboard'),
    _TabItem(icon: Icons.campaign_rounded,       label: 'Campaigns'),
    _TabItem(icon: Icons.cloud_upload_rounded,   label: 'Data'),
    _TabItem(icon: Icons.assignment_rounded,     label: 'Forms'),
    _TabItem(icon: Icons.person_rounded,         label: 'Profile'),
  ];

  // ── Screens — replace placeholders with your real screens ──────────────────
  static const _screens = [
    DashboardScreen(),       // tab 0
    CampaignsScreen(),       // tab 1
    DataScreen(),            // tab 2
    FormsScreen(),           // tab 3
    ProfileScreen(),         // tab 4
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,

      // ── IndexedStack keeps every tab alive (preserves scroll / state) ──────
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // ── Bottom Navigation Bar ───────────────────────────────────────────────
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        tabs: _tabs,
        onTap: _onTabTapped,
      ),
    );
  }
}


// ═════════════════════════════════════════════════════════════════════════════
// _BottomNavBar  — custom pill-style bottom nav matching the screenshot design
// ═════════════════════════════════════════════════════════════════════════════

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: kNavBg,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 8,
            bottom: bottomPadding > 0 ? 0 : 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) => _NavItem(
              tab: tabs[i],
              isSelected: i == currentIndex,
              onTap: () => onTap(i),
            )),
          ),
        ),
      ),
    );
  }
}


// ─── Single nav item with animated pill indicator ────────────────────────────

class _NavItem extends StatelessWidget {
  final _TabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? kPrimary.withOpacity(0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                tab.icon,
                key: ValueKey(isSelected),
                size: 24,
                color: isSelected ? kPrimary : kTextGrey,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? kPrimary : kTextGrey,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}


// ─── Tab descriptor ──────────────────────────────────────────────────────────

class _TabItem {
  final IconData icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}


// ═════════════════════════════════════════════════════════════════════════════
// ── PLACEHOLDER SCREENS ──────────────────────────────────────────────────────
// Delete these once you point the _screens list at your real feature screens.
// ═════════════════════════════════════════════════════════════════════════════

// ignore: must_be_immutable — placeholder only
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Dashboard', icon: Icons.home_rounded, color: kPrimary);
}

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Campaigns', icon: Icons.campaign_rounded, color: const Color(0xFF00B894));
}

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Data', icon: Icons.cloud_upload_rounded, color: const Color(0xFF0984E3));
}

class FormsScreen extends StatelessWidget {
  const FormsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Forms', icon: Icons.assignment_rounded, color: const Color(0xFFE17055));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      _PlaceholderScreen(label: 'Profile', icon: Icons.person_rounded, color: const Color(0xFF6C5CE7));
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  const _PlaceholderScreen({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: kBg,
    body: Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 36),
        ),
        const SizedBox(height: 16),
        Text(label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kTextDark)),
        const SizedBox(height: 6),
        Text('$label screen — replace with your real widget',
          style: const TextStyle(fontSize: 13, color: kTextGrey)),
      ]),
    ),
  );
}