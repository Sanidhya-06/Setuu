import 'package:flutter/material.dart';

class Participant {
  final String id;
  final String name;
  final String avatarUrl;
  final String email;
  final String phone;
  final String status; // 'Confirmed' | 'Pending' | 'Declined'
  final String joinedAt;
  final String role;

  const Participant({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.email,
    required this.phone,
    required this.status,
    required this.joinedAt,
    required this.role,
  });

  factory Participant.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Participant(
      id: doc.id,
      name: data['name'] ?? '',
      avatarUrl: data['avatarUrl'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      status: data['status'] ?? 'Pending',
      joinedAt: data['joinedAt'] ?? '',
      role: data['role'] ?? 'Volunteer',
    );
  }

  static Color statusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFF22C55E);
      case 'Declined':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  static Color statusBgColor(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFFDCFCE7);
      case 'Declined':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFFEF3C7);
    }
  }
}

class ParticipantTile extends StatelessWidget {
  final Participant participant;
  final VoidCallback? onTap;
  final VoidCallback? onStatusChange;

  const ParticipantTile({
    super.key,
    required this.participant,
    this.onTap,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEEEBFF),
                border: Border.all(
                  color: Participant.statusColor(participant.status)
                      .withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: participant.avatarUrl.isNotEmpty
                    ? Image.network(participant.avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback())
                    : _avatarFallback(),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          participant.name,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C1C1C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Participant.statusBgColor(participant.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          participant.status,
                          style: TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                Participant.statusColor(participant.status),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    participant.email,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 12,
                      color: Color(0xFF6B6B6B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined,
                          size: 11, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        participant.role,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.access_time_outlined,
                          size: 11, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        participant.joinedAt,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Menu / action
            GestureDetector(
              onTap: onStatusChange,
              child: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(Icons.more_vert_rounded,
                    size: 20, color: Color(0xFF6B6B6B)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: const Color(0xFFEEEBFF),
      child: const Icon(Icons.person_rounded,
          color: Color(0xFF5A4EFF), size: 22),
    );
  }
}