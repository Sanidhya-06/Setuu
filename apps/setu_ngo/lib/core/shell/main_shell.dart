import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(context),
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign),
            label: 'Campaigns',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: 'Data',
          ),
          NavigationDestination(
            icon: Icon(Icons.dynamic_form_outlined),
            selectedIcon: Icon(Icons.dynamic_form),
            label: 'Forms',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static const _tabs = [
    AppRoutes.dashboard,
    AppRoutes.campaigns,
    AppRoutes.data,
    AppRoutes.forms,
    AppRoutes.profile,
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) return i;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    final target = _tabs[index];
    final current = GoRouterState.of(context).matchedLocation;

    // Avoid redundant navigation if already on that tab root
    if (!current.startsWith(target)) {
      context.go(target);
    }
  }
}