import 'package:flutter/material.dart';
import 'package:setu_ngo/core/theme/app_theme.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Top hero: full-bleed bg image with logo + headline overlaid ──
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image covers the entire hero area
                Image.asset(
                  'assets/image/welcome.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),

                // Soft top gradient so logo/text stays readable
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        const Color(0xFFEDE9FF).withOpacity(0.93),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Logo + headline layered on top
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Logo row ──
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'NGO',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  'Connect',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ── Headline ──
                        Text(
                          'Manage Impact.',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'Drive Change.',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primaryColor,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Track data, run campaigns, collaborate\n'
                          'with volunteers, and make decisions\n'
                          'that create a better tomorrow.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom white card ──
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.fromLTRB(
              24,
              28,
              24,
              MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Three feature tiles ──
                Row(
                  children: const [
                    _FeatureTile(
                      icon: Icons.bar_chart_rounded,
                      iconBgColor: Color(0xFFEEE9FF),
                      iconColor: AppTheme.primaryColor,
                      title: 'Smart Analytics',
                      subtitle: 'Visualize data and\nmeasure real impact.',
                    ),
                    _TileDivider(),
                    _FeatureTile(
                      icon: Icons.group_rounded,
                      iconBgColor: Color(0xFFE6F9F0),
                      iconColor: Color(0xFF2DB77B),
                      title: 'Engage Volunteers',
                      subtitle: 'Connect, collaborate\nand grow together.',
                    ),
                    _TileDivider(),
                    _FeatureTile(
                      icon: Icons.campaign_rounded,
                      iconBgColor: Color(0xFFFFF3E2),
                      iconColor: Color(0xFFE8900A),
                      title: 'Run Campaigns',
                      subtitle: 'Create campaigns\nand drive change.',
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Get Started → SignupStep1 ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Replace with Navigator.push to SignupStep1Screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sign up coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Get Started',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Login → LoginScreen ──
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Replace with Navigator.push to LoginScreen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login coming soon!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      side: const BorderSide(
                        color: Color(0xFFD0CAFF),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Trust badge ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      size: 18,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure. Transparent. Impactful.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Your data is safe with us.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Feature tile widget ──
class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Thin vertical divider between tiles ──
class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 72,
      color: const Color(0xFFEEEEEE),
    );
  }
}