import 'package:flutter/material.dart';
import '../campaign_controller.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = campaign.maxVolunteers > 0
        ? (campaign.joinedCount / campaign.maxVolunteers).clamp(0.0, 1.0)
        : 0.0;
    final isFull = campaign.joinedCount >= campaign.maxVolunteers;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 110,
                height: 140,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    campaign.imageUrl.isNotEmpty
                        ? Image.network(campaign.imageUrl, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imageFallback())
                        : _imageFallback(),
                    // Badge overlay
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: campaign.badgeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          campaign.badge,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            campaign.title,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1C1C),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onMenuTap,
                          child: const Icon(Icons.more_vert_rounded,
                              size: 20, color: Color(0xFF6B6B6B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _iconRow(Icons.location_on_outlined, campaign.location),
                    const SizedBox(height: 3),
                    _iconRow(Icons.calendar_today_outlined,
                        '${campaign.date}  •  ${campaign.time}'),
                    const SizedBox(height: 6),
                    Text(
                      campaign.description,
                      style: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 12,
                        color: Color(0xFF6B6B6B),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Volunteer avatars + progress
                    Row(
                      children: [
                        _avatarStack(campaign.volunteerAvatars),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${campaign.joinedCount}/${campaign.maxVolunteers}',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isFull
                                    ? const Color(0xFF22C55E)
                                    : const Color(0xFF5A4EFF),
                              ),
                            ),
                            const Text(
                              'Volunteers',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 10,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFF0EEFF),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFull
                              ? const Color(0xFF22C55E)
                              : const Color(0xFF5A4EFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF6B6B6B)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 11,
              color: Color(0xFF6B6B6B),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _avatarStack(List<String> avatars) {
    final show = avatars.take(3).toList();
    final extra = (avatars.length - 3).clamp(0, 99);
    return SizedBox(
      height: 24,
      width: show.isEmpty ? 0 : (show.length * 18.0 + 6 + (extra > 0 ? 26 : 0)),
      child: Stack(
        children: [
          ...show.asMap().entries.map((e) => Positioned(
                left: e.key * 18.0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                    color: const Color(0xFFEEEBFF),
                  ),
                  child: ClipOval(
                    child: e.value.isNotEmpty
                        ? Image.network(e.value, fit: BoxFit.cover)
                        : const Icon(Icons.person, size: 14,
                            color: Color(0xFF5A4EFF)),
                  ),
                ),
              )),
          if (extra > 0)
            Positioned(
              left: show.length * 18.0,
              child: Container(
                width: 26,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEBFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '+$extra',
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4EFF),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFFEEEBFF),
      child: const Icon(Icons.campaign_rounded,
          color: Color(0xFF5A4EFF), size: 36),
    );
  }
}