// features/navigation/screens/main_navigation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dashboard/presentation/dashboard/dashboard_screen.dart';
import '../../campaigns/screens/campaign_list.dart';
import '../../data/screens/data_screen.dart';
import '../../forms/screens/forms_list.dart';
import '../../profile/screens/ngo_profile.dart';

// ── Colour tokens ─────────────────────────────────────────────────────────────
const kPrimary  = Color(0xFF6C5CE7);
const kBg       = Color(0xFFF5F5FA);
const kTextDark = Color(0xFF1A1A2E);
const kTextGrey = Color(0xFF9E9E9E);


// ═══════════════════════════════════════════════════════════════════════════════
// MainNavigationScreen
// ═══════════════════════════════════════════════════════════════════════════════

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  /// Exposed so child screens can jump to a tab without go_router.
  void switchTab(int index) {
    if (index == _currentIndex) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  /// Screens are built lazily here so we can pass [switchTab] to the
  /// dashboard without needing a router or InheritedWidget.
  late final List<Widget> _screens = [
    DashboardScreen(onTabSwitch: switchTab), // tab 0
    const CampaignListScreen(),              // tab 1
    const DataScreen(),                      // tab 2
    const FormsListScreen(),                 // tab 3
    const NgoProfileScreen(),               // tab 4
  ];

  static const _navItems = [
    _NavItemData(icon: Icons.home_rounded,         activeIcon: Icons.home_rounded,         label: 'Dashboard'),
    _NavItemData(icon: Icons.campaign_outlined,    activeIcon: Icons.campaign_rounded,     label: 'Campaigns'),
    _NavItemData(icon: Icons.cloud_upload_outlined,activeIcon: Icons.cloud_upload_rounded, label: 'Data'),
    _NavItemData(icon: Icons.assignment_outlined,  activeIcon: Icons.assignment_rounded,   label: 'Forms'),
    _NavItemData(icon: Icons.person_outline,       activeIcon: Icons.person_rounded,       label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      // IndexedStack keeps all tabs alive — state is preserved when switching
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _CustomBottomNav(
        currentIndex: _currentIndex,
        items: _navItems,
        onTap: switchTab,
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════════════════
// Custom Bottom Nav Bar
// ═══════════════════════════════════════════════════════════════════════════════

class _CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItemData> items;
  final ValueChanged<int> onTap;

  const _CustomBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        boxShadow: [
          BoxShadow(color: Color(0x0D000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: selected
                                ? kPrimary.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            selected ? item.activeIcon : item.icon,
                            size: 22,
                            color: selected ? kPrimary : kTextGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: selected ? kPrimary : kTextGrey,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItemData(
      {required this.icon, required this.activeIcon, required this.label});
}