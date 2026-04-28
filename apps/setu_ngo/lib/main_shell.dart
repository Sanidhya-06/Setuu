import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shell widget
// ─────────────────────────────────────────────────────────────────────────────

/// Persistent scaffold that wraps all five bottom-nav tabs.
///
/// Receives a [StatefulNavigationShell] from GoRouter's [StatefulShellRoute],
/// which preserves each branch's navigator stack independently.
class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  /// Access shell state from any descendant (e.g. to switch tabs).
  static MainShellState of(BuildContext context) {
    return context.findAncestorStateOfType<MainShellState>()!;
  }

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  // ── Bottom nav items ───────────────────────────────────────────────────────
  static const List<_NavItem> _navItems = [
    _NavItem(
      label: 'Dashboard',
      icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded,
      route: AppRoutes.dashboard,
    ),
    _NavItem(
      label: 'Campaigns',
      icon: Icons.campaign_outlined,
      activeIcon: Icons.campaign_rounded,
      route: AppRoutes.campaigns,
    ),
    _NavItem(
      label: 'Data',
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      route: AppRoutes.data,
    ),
    _NavItem(
      label: 'Forms',
      icon: Icons.article_outlined,
      activeIcon: Icons.article_rounded,
      route: AppRoutes.forms,
    ),
    _NavItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      route: AppRoutes.profile,
    ),
  ];

  int get _currentIndex => widget.navigationShell.currentIndex;

  // ── Tab switch ─────────────────────────────────────────────────────────────

  void switchToTab(int index) {
    widget.navigationShell.goBranch(
      index,
      // Re-tap the active tab → pop to root of that branch's stack.
      initialLocation: index == _currentIndex,
    );
  }

  // ── Unread notification count (wire to your provider) ─────────────────────

  // Replace with: ref.watch(unreadNotificationsCountProvider)
  int get _unreadCount => 3;

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Sync status bar icons to theme brightness.
      value: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        // ── App bar ──────────────────────────────────────────────────────────
        appBar: _ShellAppBar(
          currentIndex: _currentIndex,
          navItems: _navItems,
          unreadCount: _unreadCount,
          onNotificationsTap: () => context.push(AppRoutes.notifications),
          onMessagesTap: () => context.push(AppRoutes.inbox),
          onHelpTap: () => context.push(AppRoutes.help),
        ),

        // ── Tab bodies (IndexedStack-like, handled by StatefulShellRoute) ───
        body: widget.navigationShell,

        // ── Bottom navigation bar ────────────────────────────────────────────
        bottomNavigationBar: _ShellBottomNav(
          currentIndex: _currentIndex,
          items: _navItems,
          onTap: switchToTab,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────────────────────────────────────

class _ShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  final List<_NavItem> navItems;
  final int unreadCount;
  final VoidCallback onNotificationsTap;
  final VoidCallback onMessagesTap;
  final VoidCallback onHelpTap;

  const _ShellAppBar({
    required this.currentIndex,
    required this.navItems,
    required this.unreadCount,
    required this.onNotificationsTap,
    required this.onMessagesTap,
    required this.onHelpTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        navItems[currentIndex].label,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
      ),
      centerTitle: false,
      scrolledUnderElevation: 0,
      actions: [
        // Help
        IconButton(
          icon: const Icon(Icons.help_outline_rounded),
          tooltip: 'Help',
          onPressed: onHelpTap,
        ),
        // Messaging
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          tooltip: 'Messages',
          onPressed: onMessagesTap,
        ),
        // Notifications with badge
        _NotificationBell(
          unreadCount: unreadCount,
          onTap: onNotificationsTap,
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────

class _ShellBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_NavItem> items;
  final void Function(int) onTap;

  const _ShellBottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      animationDuration: const Duration(milliseconds: 300),
      destinations: items
          .map(
            (item) => NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.activeIcon, color: colorScheme.primary),
              label: item.label,
              tooltip: item.label,
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification bell with badge
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationBell extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _NotificationBell({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
          onPressed: onTap,
        ),
        if (unreadCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints:
                    const BoxConstraints(minWidth: 18, minHeight: 14),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav item data class
// ─────────────────────────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Convenience extensions used by screens
// ─────────────────────────────────────────────────────────────────────────────

extension ShellNavigation on BuildContext {
  /// Switch to any shell tab from any screen.
  ///
  /// ```dart
  /// context.switchToTab(2); // go to Data tab
  /// ```
  void switchToTab(int index) => MainShell.of(this).switchToTab(index);

  /// Navigate and switch tab in one call — useful for cross-tab deep-links.
  ///
  /// ```dart
  /// context.goToTab(index: 1, path: AppRoutes.campaignCreate);
  /// ```
  void goToTab({required int index, String? path}) {
    MainShell.of(this).switchToTab(index);
    if (path != null) go(path);
  }
}