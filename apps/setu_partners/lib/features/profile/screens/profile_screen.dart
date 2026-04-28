import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── theme colours ──────────────────────────────────────────────────────────
  static const Color _primary = Color(0xFF6C4EF2);
  static const Color _primaryLight = Color(0xFFEDE9FF);
  static const Color _accent = Color(0xFF8B70F5);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textGrey = Color(0xFF9E9E9E);
  static const Color _cardBg = Colors.white;

  // ── state ──────────────────────────────────────────────────────────────────
  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // ── Firestore fetch ────────────────────────────────────────────────────────
  Future<void> _fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('Not authenticated');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) throw Exception('User document not found');

      setState(() {
        _userData = doc.data();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await FirebaseAuth.instance.signOut();
      // Navigate to WelcomeScreen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/welcome', // ← change to your welcome route name
        (route) => false,
      );
    }
  }

  // ── helpers ────────────────────────────────────────────────────────────────
  List<String> _parseInterests(dynamic raw) {
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is String) return [raw];
    return [];
  }

  // ── build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: _primary))
          : _error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _fetchUserData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final name = _userData?['name'] ?? 'User';
    final email = _userData?['email'] ?? '';
    final location = _userData?['location'] ?? '';
    final interests = _parseInterests(_userData?['interests']);
    final role = _userData?['role'] ?? 'Volunteer';
    final joinedAt = _userData?['createdAt'];
    final totalActivities = _userData?['totalActivities'] ?? 0;
    final impactScore = _userData?['impactScore'] ?? 0;

    String joinedStr = '';
    if (joinedAt != null) {
      DateTime dt;
      if (joinedAt is Timestamp) {
        dt = joinedAt.toDate();
      } else if (joinedAt is String) {
        dt = DateTime.tryParse(joinedAt) ?? DateTime.now();
      } else {
        dt = DateTime.now();
      }
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      joinedStr = '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    }

    return CustomScrollView(
      slivers: [
        // ── App Bar ─────────────────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 0,
          floating: true,
          backgroundColor: const Color(0xFFF5F4FF),
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded,
                      color: _textDark, size: 28),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                        color: _primary, shape: BoxShape.circle),
                    child: const Center(
                      child: Text('3',
                          style:
                              TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            child: Column(
              children: [
                // ── Hero card ──────────────────────────────────────────────
                _HeroCard(name: name, role: role),
                const SizedBox(height: 16),

                // ── Contact info card ──────────────────────────────────────
                _InfoCard(children: [
                  _InfoRow(
                      icon: Icons.email_outlined, text: email),
                  const Divider(height: 1),
                  _InfoRow(
                      icon: Icons.location_on_outlined, text: location),
                ]),
                const SizedBox(height: 16),

                // ── Interests card ─────────────────────────────────────────
                if (interests.isNotEmpty) ...[
                  _SectionCard(
                    title: 'Interests',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interests
                          .map((i) => _InterestChip(label: i))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Stats card ─────────────────────────────────────────────
                _InfoCard(children: [
                  _StatRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Role',
                    value: role,
                    valueColor: _primary,
                  ),
                  const Divider(height: 1),
                  _StatRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Joined On',
                    value: joinedStr,
                  ),
                  const Divider(height: 1),
                  _StatRow(
                    icon: Icons.shield_outlined,
                    label: 'Total Activities',
                    value: totalActivities.toString(),
                    valueColor: _primary,
                  ),
                  const Divider(height: 1),
                  _StatRow(
                    icon: Icons.star_outline_rounded,
                    label: 'Impact Score',
                    value: impactScore.toString(),
                    valueColor: _primary,
                  ),
                ]),
                const SizedBox(height: 24),

                // ── Edit Profile button ────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 20),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      // TODO: navigate to edit profile screen
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // ── Logout button ──────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.logout_rounded,
                        color: _primary, size: 20),
                    label: const Text(
                      'Log Out',
                      style: TextStyle(
                          color: _primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: _logout,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final String name;
  final String role;
  const _HeroCard({required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF6C4EF2).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Purple banner
          Container(
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC5B8FF), Color(0xFFEDE9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          // Avatar overlapping banner
          Transform.translate(
            offset: const Offset(0, -40),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFEDE9FF),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(Icons.person,
                      size: 52, color: Color(0xFF6C4EF2)),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFFEDE9FF), width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4)
                    ],
                  ),
                  child: const Icon(Icons.edit,
                      size: 14, color: Color(0xFF6C4EF2)),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Column(
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE9FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(role,
                      style: const TextStyle(
                          color: Color(0xFF6C4EF2),
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF6C4EF2).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF6C4EF2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF1A1A2E))),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF6C4EF2).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  const _InterestChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF6C4EF2).withOpacity(0.3), width: 1),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFF6C4EF2),
              fontSize: 13,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = const Color(0xFF1A1A2E),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                Icon(icon, color: const Color(0xFF6C4EF2), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, color: Color(0xFF9E9E9E))),
          ),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor)),
        ],
      ),
    );
  }
}