import 'package:flutter/material.dart';

import '../../../core/providers/dashboard_provider.dart';
import '../../../../../core/theme/app_theme.dart';

// Sub-screen imports
import '../../../presentation/analytics/analytics_screen.dart';
import '../../../presentation/heatmap/heatmap_screen.dart';
import '../../../../campaigns/screens/campaign_list.dart';
import '../../../../campaigns/screens/create_campaign.dart';
import '../../../../data/screens/data_screen.dart';
import '../../../../data/screens/data_upload_screen.dart';
import '../../../../forms/screens/forms_list.dart';
import '../../../../forms/screens/form_builder.dart';

// Shared widgets
import '../../../../dashboard/presentation/dashboard/dashboard_widgets.dart';

import 'dashboard_app_bar.dart';
import 'dashboard_quick_actions.dart';

class DashboardBody extends StatelessWidget {
  final DashboardProvider provider;
  final ValueChanged<int>? onTabSwitch;

  const DashboardBody({
    super.key,
    required this.provider,
    this.onTabSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final stats = provider.stats;
    final theme = Theme.of(context);

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: provider.refresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DashboardAppBar(ngoName: provider.ngoName),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Stat cards ──────────────────────────────
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
                      iconBg: AppTheme.primaryColor.withOpacity(0.1),
                      iconColor: AppTheme.primaryColor,
                      label: 'Campaigns',
                      value: stats.totalCampaigns.toString(),
                      changePercent: stats.campaignChange,
                    ),
                    StatCard(
                      icon: Icons.group_rounded,
                      iconBg: AppTheme.accentGreen,
                      iconColor: Colors.green,
                      label: 'Volunteers',
                      value: stats.totalVolunteers.toString(),
                      changePercent: stats.volunteerChange,
                    ),
                    StatCard(
                      icon: Icons.bar_chart_rounded,
                      iconBg: AppTheme.secondaryColor.withOpacity(0.15),
                      iconColor: AppTheme.secondaryColor,
                      label: 'Reports',
                      value: stats.totalReports.toString(),
                      changePercent: stats.reportChange,
                    ),
                    StatCard(
                      icon: Icons.favorite_rounded,
                      iconBg: Colors.red.withOpacity(0.1),
                      iconColor: Colors.red,
                      label: 'Impact Score',
                      value: '${stats.impactScore}/100',
                      changePercent: stats.impactChange,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Trend chart ─────────────────────────────
                TrendLineChart(
                  points: provider.trend,
                  totalParticipants:
                      provider.trend.fold(0, (s, p) => s + p.count),
                  changePercent: stats.reportChange,
                ),

                const SizedBox(height: 12),

                // ── Donut chart ─────────────────────────────
                DonutChart(categories: provider.categories),

                const SizedBox(height: 12),

                // ── Top campaign ────────────────────────────
                if (provider.topCampaign != null) ...[
                  TopCampaignCard(campaign: provider.topCampaign!),
                  const SizedBox(height: 20),
                ],

                // ── Quick Actions ───────────────────────────
                const SectionTitle(title: 'Quick Actions'),
                const SizedBox(height: 12),
                DashboardQuickActions(onTabSwitch: onTabSwitch),

                const SizedBox(height: 20),

                // ── Heatmap ─────────────────────────────────
                SectionTitle(
                  title: 'Impact Heatmap',
                  action: 'View Map',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HeatmapScreen()),
                  ),
                ),

                const SizedBox(height: 12),
                IssueHeatmap(points: provider.heatPoints),

                const SizedBox(height: 20),

                // ── Recent Activity ─────────────────────────
                SectionTitle(
                  title: 'Recent Activity',
                  action: 'View All',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
                  ),
                ),

                const SizedBox(height: 12),

                if (provider.recentActivity.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No uploads yet',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...provider.recentActivity
                      .map((a) => ActivityTile(activity: a)),

                const SizedBox(height: 20),

                // ── Upcoming Campaigns ──────────────────────
                SectionTitle(
                  title: 'Upcoming Campaigns',
                  action: 'View All',
                  onAction: () => onTabSwitch?.call(1),
                ),

                const SizedBox(height: 12),

                if (provider.upcomingCampaigns.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'No upcoming campaigns',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  ...provider.upcomingCampaigns
                      .map((c) => CampaignTile(campaign: c)),

                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}