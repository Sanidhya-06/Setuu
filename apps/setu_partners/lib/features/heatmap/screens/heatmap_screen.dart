import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../heatmap_controller.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  late final HeatmapController _controller;
  final MapController _mapController = MapController();

  static const _indiaCenter = LatLng(20.5937, 78.9629);

  @override
  void initState() {
    super.initState();
    _controller = HeatmapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = context.read<AppState>().currentUser;
      _controller.init(currentUser?.uid ?? '');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _zoomToIndia() {
    _mapController.move(_indiaCenter, 5.0);
  }

  List<Marker> _buildMarkers() {
    if (_controller.mode == MapMode.volunteers) {
      return _controller.users.map((u) {
        final isMe = u.uid == _controller.currentUserUid;
        return Marker(
          point: u.latLng,
          width: 36,
          height: 36,
          child: GestureDetector(
            onTap: () => _controller.selectUser(u),
            child: Icon(
              Icons.location_pin,
              size: 36,
              color: isMe
                  ? const Color(0xFF5A4EFF)
                  : const Color(0xFF2196F3),
            ),
          ),
        );
      }).toList();
    } else {
      return _controller.issues.map((issue) {
        return Marker(
          point: issue.latLng,
          width: 36,
          height: 36,
          child: GestureDetector(
            onTap: () => _controller.selectIssue(issue),
            child: Icon(
              Icons.location_pin,
              size: 36,
              color: issue.statusColor,
            ),
          ),
        );
      }).toList();
    }
  }

  List<CircleMarker> _buildCircles() {
    if (_controller.mode == MapMode.volunteers) {
      return _controller.users.map((u) {
        final isMe = u.uid == _controller.currentUserUid;
        return CircleMarker(
          point: u.latLng,
          radius: 8000,
          useRadiusInMeter: true,
          color: isMe
              ? const Color(0xFF5A4EFF).withOpacity(0.22)
              : const Color(0xFF2196F3).withOpacity(0.12),
          borderColor: isMe
              ? const Color(0xFF5A4EFF).withOpacity(0.5)
              : const Color(0xFF2196F3).withOpacity(0.2),
          borderStrokeWidth: 1,
        );
      }).toList();
    } else {
      return _controller.issues.map((issue) {
        return CircleMarker(
          point: issue.latLng,
          radius: 12000,
          useRadiusInMeter: true,
          color: issue.statusColor.withOpacity(0.18),
          borderColor: issue.statusColor.withOpacity(0.4),
          borderStrokeWidth: 1,
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F4FF),
          body: SafeArea(
            child: Stack(
              children: [
                // ── flutter_map (OpenStreetMap) ─────────────────────────────
                _controller.isLoading && _controller.users.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF5A4EFF)),
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _indiaCenter,
                          initialZoom: 5,
                          onTap: (_, __) => _controller.clearSelection(),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.yourapp.app', // ← change to your package name
                          ),
                          CircleLayer(circles: _buildCircles()),
                          MarkerLayer(markers: _buildMarkers()),
                        ],
                      ),

                // ── Top Bar ────────────────────────────────────────────────
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _TopBar(controller: _controller),
                ),

                // ── Mode Toggle ────────────────────────────────────────────
                Positioned(
                  top: 80,
                  left: 20,
                  right: 20,
                  child: _ModeToggle(controller: _controller),
                ),

                // ── Legend ─────────────────────────────────────────────────
                Positioned(
                  bottom: _controller.selectedUser != null ||
                          _controller.selectedIssue != null
                      ? 220
                      : 100,
                  right: 16,
                  child: _Legend(mode: _controller.mode),
                ),

                // ── Zoom to India button ────────────────────────────────────
                Positioned(
                  bottom: _controller.selectedUser != null ||
                          _controller.selectedIssue != null
                      ? 220
                      : 100,
                  left: 16,
                  child: _MapButton(
                    icon: Icons.map_rounded,
                    onTap: _zoomToIndia,
                    tooltip: 'Zoom to India',
                  ),
                ),

                // ── Stats / Detail Sheet ───────────────────────────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _controller.selectedUser != null
                      ? _UserDetailSheet(
                          user: _controller.selectedUser!,
                          isMe: _controller.selectedUser!.uid ==
                              context.read<AppState>().currentUser?.uid,
                          onClose: _controller.clearSelection,
                        )
                      : _controller.selectedIssue != null
                          ? _IssueDetailSheet(
                              issue: _controller.selectedIssue!,
                              onClose: _controller.clearSelection,
                            )
                          : _StatsBar(controller: _controller),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final HeatmapController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.chevron_left_rounded,
                color: Color(0xFF1C1C1C), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Volunteer Heatmap',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                Text(
                  controller.mode == MapMode.volunteers
                      ? '${controller.users.length} volunteers mapped'
                      : '${controller.issues.length} issues reported',
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ),
          if (controller.isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  color: Color(0xFF5A4EFF), strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}

// ── Mode Toggle ───────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final HeatmapController controller;
  const _ModeToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _ToggleTab(
            label: '👥  Volunteers',
            isActive: controller.mode == MapMode.volunteers,
            onTap: () => controller.setMode(MapMode.volunteers),
          ),
          _ToggleTab(
            label: '⚠️  Issues',
            isActive: controller.mode == MapMode.issues,
            onTap: () => controller.setMode(MapMode.issues),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF5A4EFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : const Color(0xFF6B6B6B),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Legend ────────────────────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  final MapMode mode;
  const _Legend({required this.mode});

  @override
  Widget build(BuildContext context) {
    final items = mode == MapMode.volunteers
        ? [
            _LegendItem(color: const Color(0xFF5A4EFF), label: 'You'),
            _LegendItem(color: const Color(0xFF2196F3), label: 'Volunteer'),
          ]
        : [
            _LegendItem(color: const Color(0xFFE53935), label: 'Pending'),
            _LegendItem(color: const Color(0xFFFF8F00), label: 'In Progress'),
            _LegendItem(color: const Color(0xFF2E7D32), label: 'Resolved'),
          ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: items,
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 11,
                  color: Color(0xFF1C1C1C))),
        ],
      ),
    );
  }
}

// ── Map Button ────────────────────────────────────────────────────────────────

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _MapButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF5A4EFF), size: 20),
        ),
      ),
    );
  }
}

// ── Stats Bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  final HeatmapController controller;
  const _StatsBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final issues = controller.issues;
    final pending = issues.where((i) => i.status == 'pending').length;
    final inProgress = issues.where((i) => i.status == 'in_progress').length;
    final resolved = issues.where((i) => i.status == 'resolved').length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: controller.mode == MapMode.volunteers
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  value: '${controller.users.length}',
                  label: 'Volunteers',
                  color: const Color(0xFF5A4EFF),
                  icon: Icons.group_rounded,
                ),
                _divider(),
                _StatItem(
                  value: _topState(controller.users),
                  label: 'Top State',
                  color: const Color(0xFF2196F3),
                  icon: Icons.location_on_rounded,
                ),
                _divider(),
                _StatItem(
                  value: _topInterest(controller.users),
                  label: 'Top Interest',
                  color: const Color(0xFF2E7D32),
                  icon: Icons.favorite_rounded,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  value: '$pending',
                  label: 'Pending',
                  color: const Color(0xFFE53935),
                  icon: Icons.error_outline_rounded,
                ),
                _divider(),
                _StatItem(
                  value: '$inProgress',
                  label: 'In Progress',
                  color: const Color(0xFFFF8F00),
                  icon: Icons.autorenew_rounded,
                ),
                _divider(),
                _StatItem(
                  value: '$resolved',
                  label: 'Resolved',
                  color: const Color(0xFF2E7D32),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ],
            ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: const Color(0xFFE0E0E0),
      );

  String _topState(List<HeatmapUser> users) {
    if (users.isEmpty) return '-';
    final freq = <String, int>{};
    for (final u in users) {
      final parts = u.location.split(',');
      final state = parts.length >= 2 ? parts[1].trim() : u.location;
      freq[state] = (freq[state] ?? 0) + 1;
    }
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String _topInterest(List<HeatmapUser> users) {
    if (users.isEmpty) return '-';
    final freq = <String, int>{};
    for (final u in users) {
      for (final i in u.interests) {
        freq[i] = (freq[i] ?? 0) + 1;
      }
    }
    if (freq.isEmpty) return '-';
    return freq.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            )),
        Text(label,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 11,
              color: Color(0xFF6B6B6B),
            )),
      ],
    );
  }
}

// ── User Detail Sheet ─────────────────────────────────────────────────────────

class _UserDetailSheet extends StatelessWidget {
  final HeatmapUser user;
  final bool isMe;
  final VoidCallback onClose;

  const _UserDetailSheet({
    required this.user,
    required this.isMe,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isMe
            ? Border.all(color: const Color(0xFF5A4EFF), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEBFF),
                  shape: BoxShape.circle,
                  border: isMe
                      ? Border.all(color: const Color(0xFF5A4EFF), width: 2)
                      : null,
                ),
                child: const Icon(Icons.person_rounded,
                    color: Color(0xFF5A4EFF), size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.name}${isMe ? ' (You)' : ''}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1C),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xFF6B6B6B)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            user.location,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 12,
                              color: Color(0xFF6B6B6B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close_rounded,
                    color: Color(0xFF6B6B6B), size: 20),
              ),
            ],
          ),
          if (user.interests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.interests
                  .map((i) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEBFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(i,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF5A4EFF),
                            )),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Issue Detail Sheet ────────────────────────────────────────────────────────

class _IssueDetailSheet extends StatelessWidget {
  final IssueReport issue;
  final VoidCallback onClose;

  const _IssueDetailSheet({required this.issue, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: issue.statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(issue.issueIcon,
                    color: issue.statusColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(issue.issueType,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1C),
                        )),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: Color(0xFF6B6B6B)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(issue.location,
                              style: const TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 12,
                                color: Color(0xFF6B6B6B),
                              ),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: issue.statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  issue.status == 'in_progress'
                      ? 'In Progress'
                      : issue.status[0].toUpperCase() +
                          issue.status.substring(1),
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: issue.statusColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close_rounded,
                    color: Color(0xFF6B6B6B), size: 20),
              ),
            ],
          ),
          if (issue.description.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              issue.description,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 13,
                color: Color(0xFF6B6B6B),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (issue.createdAt != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 13, color: Color(0xFF6B6B6B)),
                const SizedBox(width: 4),
                Text(
                  _formatDate(issue.createdAt!),
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 11,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_month(date.month)} ${date.year}';
  }

  String _month(int m) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m];
  }
}