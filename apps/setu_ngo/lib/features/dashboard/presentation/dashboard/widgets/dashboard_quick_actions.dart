// features/dashboard/presentation/dashboard/widgets/dashboard_quick_actions.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../campaigns/screens/create_campaign.dart';
import '../../../../campaigns/campaign_controller.dart';
import '../../../../data/screens/data_upload_screen.dart';
import '../../../../forms/screens/form_builder.dart';
import '../../../presentation/analytics/analytics_screen.dart';

/// Tab indices matching MainNavigationScreen._screens order
const _kTabCampaigns = 1;
const _kTabData      = 2;

class DashboardQuickActions extends StatelessWidget {
  final ValueChanged<int>? onTabSwitch;

  const DashboardQuickActions({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickAction>[
      _QuickAction(
        icon: Icons.campaign_rounded,
        label: 'Create\nCampaign',
        bgColor: AppTheme.primaryColor.withOpacity(0.12),
        iconColor: AppTheme.primaryColor,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateCampaignScreen(
              controller: context.read<CampaignController>(),
            ),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.upload_rounded,
        label: 'Add Data /\nUpload',
        bgColor: const Color(0xFFE6F9F0),
        iconColor: const Color(0xFF00B894),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DataUploadScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.assignment_rounded,
        label: 'Create\nForm',
        bgColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FormBuilderScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.bar_chart_rounded,
        label: 'View\nAnalytics',
        bgColor: const Color(0xFFFFF3E2),
        iconColor: const Color(0xFFE17055),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
        ),
      ),
      _QuickAction(
        icon: Icons.group_add_rounded,
        label: 'Invite\nVolunteers',
        bgColor: AppTheme.primaryColor.withOpacity(0.12),
        iconColor: AppTheme.primaryColor,
        onTap: () => onTabSwitch?.call(_kTabCampaigns),
      ),
      _QuickAction(
        icon: Icons.description_rounded,
        label: 'View\nReports',
        bgColor: const Color(0xFFFFEBEE),
        iconColor: const Color(0xFFD63031),
        onTap: () => onTabSwitch?.call(_kTabData),
      ),
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final a = actions[i];
          return GestureDetector(
            onTap: a.onTap,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: a.bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(a.icon, color: a.iconColor, size: 26),
                ),
                const SizedBox(height: 6),
                Text(
                  a.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        height: 1.3,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}