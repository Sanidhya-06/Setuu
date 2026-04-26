import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../campaign_controller.dart';
import '../widgets/participant_tile.dart';

class ParticipantsListScreen extends StatefulWidget {
  final Campaign campaign;

  const ParticipantsListScreen({super.key, required this.campaign});

  @override
  State<ParticipantsListScreen> createState() =>
      _ParticipantsListScreenState();
}

class _ParticipantsListScreenState extends State<ParticipantsListScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _loading = true;
  String? _error;
  List<Participant> _participants = [];

  final List<String> _filters = ['All', 'Confirmed', 'Pending', 'Declined'];

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> _fetchParticipants() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final snap = await _db
          .collection('campaigns')
          .doc(widget.campaign.id)
          .collection('participants')
          .orderBy('joinedAt', descending: true)
          .get();
      _participants =
          snap.docs.map((d) => Participant.fromFirestore(d)).toList();
    } catch (e) {
      _error = 'Failed to load participants. Please try again.';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Participant> get _filtered {
    return _participants.where((p) {
      final matchesFilter =
          _selectedFilter == 'All' || p.status == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.email.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  Future<void> _updateStatus(Participant p, String newStatus) async {
    try {
      await _db
          .collection('campaigns')
          .doc(widget.campaign.id)
          .collection('participants')
          .doc(p.id)
          .update({'status': newStatus});
      await _fetchParticipants();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update status.',
                style: TextStyle(fontFamily: 'Rubik')),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showStatusSheet(Participant participant) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              participant.name,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              participant.email,
              style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  color: Color(0xFF6B6B6B)),
            ),
            const SizedBox(height: 16),
            const Text('Update Status',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1C),
                )),
            const SizedBox(height: 10),
            ...['Confirmed', 'Pending', 'Declined'].map(
              (s) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Participant.statusBgColor(s),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    s == 'Confirmed'
                        ? Icons.check_circle_outline
                        : s == 'Declined'
                            ? Icons.cancel_outlined
                            : Icons.hourglass_empty_rounded,
                    color: Participant.statusColor(s),
                    size: 18,
                  ),
                ),
                title: Text(s,
                    style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.w500)),
                trailing: participant.status == s
                    ? const Icon(Icons.check_rounded,
                        color: Color(0xFF5A4EFF))
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  _updateStatus(participant, s);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showParticipantDetail(Participant p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEEEBFF),
                border: Border.all(
                    color: Participant.statusColor(p.status).withOpacity(0.4),
                    width: 3),
              ),
              child: ClipOval(
                child: p.avatarUrl.isNotEmpty
                    ? Image.network(p.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: Color(0xFF5A4EFF),
                            size: 36))
                    : const Icon(Icons.person_rounded,
                        color: Color(0xFF5A4EFF), size: 36),
              ),
            ),
            const SizedBox(height: 12),
            Text(p.name,
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Participant.statusBgColor(p.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(p.status,
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Participant.statusColor(p.status),
                  )),
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.email_outlined, p.email),
            const SizedBox(height: 8),
            _detailRow(Icons.phone_outlined, p.phone),
            const SizedBox(height: 8),
            _detailRow(Icons.badge_outlined, p.role),
            const SizedBox(height: 8),
            _detailRow(Icons.access_time_outlined, 'Joined: ${p.joinedAt}'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateStatus(p, 'Declined');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Decline',
                        style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _updateStatus(p, 'Confirmed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm',
                        style: TextStyle(
                            fontFamily: 'Rubik',
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B6B6B)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  color: Color(0xFF1C1C1C))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final confirmed = _participants.where((p) => p.status == 'Confirmed').length;
    final pending = _participants.where((p) => p.status == 'Pending').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1C1C1C), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Participants',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1C1C),
                )),
            Text(
              widget.campaign.title,
              style: const TextStyle(
                fontFamily: 'Rubik',
                fontSize: 11,
                color: Color(0xFF6B6B6B),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF5A4EFF)),
            onPressed: _fetchParticipants,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Stats Row ────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                _statChip(
                  '${_participants.length}',
                  'Total',
                  const Color(0xFF5A4EFF),
                  const Color(0xFFEEEBFF),
                ),
                const SizedBox(width: 10),
                _statChip(
                  '$confirmed',
                  'Confirmed',
                  const Color(0xFF22C55E),
                  const Color(0xFFDCFCE7),
                ),
                const SizedBox(width: 10),
                _statChip(
                  '$pending',
                  'Pending',
                  const Color(0xFFF59E0B),
                  const Color(0xFFFEF3C7),
                ),
                const Spacer(),
                // Capacity indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${widget.campaign.joinedCount}/${widget.campaign.maxVolunteers}',
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A4EFF),
                      ),
                    ),
                    const Text('capacity',
                        style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 10,
                            color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),
          ),

          // ── Search ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 6)
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: Color(0xFF1C1C1C)),
                decoration: const InputDecoration(
                  hintText: 'Search by name or email...',
                  hintStyle: TextStyle(
                      fontFamily: 'Rubik', color: Color(0xFF6B6B6B)),
                  prefixIcon: Icon(Icons.search_rounded,
                      color: Color(0xFF6B6B6B), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // ── Filter chips ─────────────────────────────────────────────────
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final f = _filters[i];
                final isSelected = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5A4EFF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF5A4EFF)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF5A4EFF)))
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: Color(0xFF6B6B6B), size: 40),
                            const SizedBox(height: 12),
                            Text(_error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Color(0xFF6B6B6B))),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _fetchParticipants,
                              child: const Text('Retry',
                                  style: TextStyle(
                                      fontFamily: 'Rubik',
                                      color: Color(0xFF5A4EFF),
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      )
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people_outline_rounded,
                                    size: 56,
                                    color: Colors.grey.shade300),
                                const SizedBox(height: 12),
                                const Text('No participants found',
                                    style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 15,
                                        color: Color(0xFF6B6B6B))),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchParticipants,
                            color: const Color(0xFF5A4EFF),
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 12, 16, 80),
                              itemCount: filtered.length,
                              itemBuilder: (_, i) => ParticipantTile(
                                participant: filtered[i],
                                onTap: () =>
                                    _showParticipantDetail(filtered[i]),
                                onStatusChange: () =>
                                    _showStatusSheet(filtered[i]),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(
      String count, String label, Color textColor, Color bgColor) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(count,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: textColor,
              )),
          Text(label,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: textColor,
              )),
        ],
      ),
    );
  }
}