import 'package:flutter/material.dart';

import '../../../../notifications/screens/notifications_screen.dart';
import '../../../../../core/theme/app_theme.dart';

class DashboardAppBar extends StatelessWidget {
  final String ngoName;
  const DashboardAppBar({super.key, required this.ngoName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: theme.iconTheme.color,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $ngoName 👋',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Here's what's happening today",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  size: 26,
                  color: theme.iconTheme.color,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.red, // keeping red for alert visibility
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}