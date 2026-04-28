import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppTheme.primaryColor,
            strokeWidth: 2.5,
          ),

          const SizedBox(height: 16),

          Text(
            'Loading dashboard...',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}