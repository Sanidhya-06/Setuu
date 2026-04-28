import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

class DashboardErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: AppTheme.textSecondary,
              size: 48,
            ),

            const SizedBox(height: 16),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: onRetry,
              // ❌ removed manual styling → uses your global theme
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}