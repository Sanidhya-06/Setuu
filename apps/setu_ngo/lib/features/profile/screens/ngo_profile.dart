import 'package:flutter/material.dart';
import '../models/ngo_profile_model.dart';
import '../services/profile_service.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/organization_info_sheet.dart';

class NgoProfileScreen extends StatefulWidget {
  /// Called after the user confirms logout and [ProfileService.logout] succeeds.
  /// The parent ([MainNavigationScreen]) delegates this to [AuthState.logout],
  /// which causes [AuthWrapper] to swap to [WelcomeScreen] automatically.
  final Future<void> Function() onLogout;

  const NgoProfileScreen({super.key, required this.onLogout});

  @override
  State<NgoProfileScreen> createState() => _NgoProfileScreenState();
}

class _NgoProfileScreenState extends State<NgoProfileScreen> {
  final ProfileService _profileService = ProfileService();
  NgoProfile? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await _profileService.fetchProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF888888)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: Color(0xFFE53935),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _profileService.logout();   // clear tokens / session in your service
      if (!mounted) return;
      await widget.onLogout();          // ← notifies AuthState → AuthWrapper rebuilds
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F4FF),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NGO Profile',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              'Manage your organization and impact.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1A2E)),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B5ECD)),
            )
          : _error != null
              ? _buildError()
              : _buildBody(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(
            'Failed to load profile',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadProfile,
            child: const Text(
              'Retry',
              style: TextStyle(color: Color(0xFF6B5ECD)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final profile = _profile!;
    return RefreshIndicator(
      color: const Color(0xFF6B5ECD),
      onRefresh: _loadProfile,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // Header card
          ProfileHeaderWidget(
            profile: profile,
            onImageUpdated: _loadProfile,
          ),

          // Quick Navigation Buttons
          _buildQuickNavButtons(),

          const SizedBox(height: 8),

          // Menu Items
          _buildMenuSection([
            _MenuItem(
              icon: Icons.business_outlined,
              iconBg: const Color(0xFFEDE9FF),
              iconColor: const Color(0xFF6B5ECD),
              title: 'Organization Information',
              subtitle: 'View and edit your NGO details',
              onTap: () =>
                  OrganizationInfoSheet.show(context, profile.organizationInfo),
            ),
            _MenuItem(
              icon: Icons.security_outlined,
              iconBg: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF43A047),
              title: 'Privacy & Security',
              subtitle: 'Manage your account security',
              onTap: () => _showComingSoon('Privacy & Security'),
            ),
            _MenuItem(
              icon: Icons.help_outline,
              iconBg: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFF57C00),
              title: 'Help & Support',
              subtitle: 'Get help and contact support',
              onTap: () => _showComingSoon('Help & Support'),
            ),
          ]),

          const SizedBox(height: 16),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(
                Icons.logout,
                color: Color(0xFFE53935),
                size: 18,
              ),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Color(0xFFE53935),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        backgroundColor: const Color(0xFF6B5ECD),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildQuickNavButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B5ECD).withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _QuickNavButton(
              icon: Icons.campaign_outlined,
              label: 'Add Campaign',
              color: const Color(0xFF6B5ECD),
              bgColor: const Color(0xFFEDE9FF),
              onTap: () => _showComingSoon('Add Campaign'),
            ),
            _QuickNavButton(
              icon: Icons.article_outlined,
              label: 'Create Form',
              color: const Color(0xFF5B9BD5),
              bgColor: const Color(0xFFE3F0FF),
              onTap: () => _showComingSoon('Create Form'),
            ),
            _QuickNavButton(
              icon: Icons.bar_chart_outlined,
              label: 'View Reports',
              color: const Color(0xFF43A47D),
              bgColor: const Color(0xFFE8F5EE),
              onTap: () => _showComingSoon('View Reports'),
            ),
            _QuickNavButton(
              icon: Icons.share_outlined,
              label: 'Share Impact',
              color: const Color(0xFFF06292),
              bgColor: const Color(0xFFFFE8F0),
              onTap: () => _showComingSoon('Share Impact'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B5ECD).withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                _buildMenuItem(entry.value),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 64,
                    endIndent: 16,
                    color: Colors.grey[100],
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFCCCCCC),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}

class _QuickNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickNavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 68,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}