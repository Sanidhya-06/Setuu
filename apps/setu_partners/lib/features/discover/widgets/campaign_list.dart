import 'package:flutter/material.dart';
import '../discover_controller.dart';

class CampaignListCard extends StatelessWidget {
  final Campaign campaign;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const CampaignListCard({
    super.key,
    required this.campaign,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badge + Save ─────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: campaign.imageUrl.isNotEmpty
                        ? Image.network(
                            campaign.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                if (campaign.badge.isNotEmpty)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onSave,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSaved
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isSaved
                            ? const Color(0xFFE53935)
                            : const Color(0xFF6B6B6B),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1C1C),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.description,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 11,
                      color: Color(0xFF6B6B6B),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Color(0xFF6B6B6B)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          campaign.location,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 11,
                            color: Color(0xFF6B6B6B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: Color(0xFF6B6B6B)),
                      const SizedBox(width: 4),
                      Text(
                        campaign.date,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 11,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ── Volunteer avatars + joined count ─────────────────────
                  Row(
                    children: [
                      // Stacked avatars
                      SizedBox(
                        width: campaign.volunteerAvatars.length > 4
                            ? 4 * 18.0 + 24
                            : campaign.volunteerAvatars.length * 18.0 + 6,
                        height: 24,
                        child: Stack(
                          children: [
                            ...List.generate(
                              campaign.volunteerAvatars.length > 4
                                  ? 4
                                  : campaign.volunteerAvatars.length,
                              (i) => Positioned(
                                left: i * 18.0,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      campaign.volunteerAvatars[i],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xFFEEEBFF),
                                        child: const Icon(
                                            Icons.person_rounded,
                                            size: 14,
                                            color: Color(0xFF5A4EFF)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (campaign.joinedCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A4EFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${campaign.joinedCount}',
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${campaign.joinedCount} Joined',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5A4EFF),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEEEBFF),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF5A4EFF), size: 36),
      ),
    );
  }
}

// ── Upcoming Event Card ───────────────────────────────────────────────────────

class UpcomingEventCard extends StatelessWidget {
  final UpcomingEvent event;
  final bool isSaved;
  final VoidCallback onSave;
  final VoidCallback onTap;

  const UpcomingEventCard({
    super.key,
    required this.event,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date box
            Container(
              width: 56,
              height: 66,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEBFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.month.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A4EFF),
                    ),
                  ),
                  Text(
                    event.day,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4EFF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 80,
                height: 66,
                child: event.imageUrl.isNotEmpty
                    ? Image.network(event.imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFEEEBFF),
                        ))
                    : Container(color: const Color(0xFFEEEBFF)),
              ),
            ),
            const SizedBox(width: 12),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 11,
                      color: Color(0xFF6B6B6B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 11, color: Color(0xFF6B6B6B)),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 10,
                            color: Color(0xFF6B6B6B),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.access_time_outlined,
                          size: 11, color: Color(0xFF6B6B6B)),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          event.timeRange,
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 10,
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

            // Save icon
            GestureDetector(
              onTap: onSave,
              child: Icon(
                isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                color: isSaved
                    ? const Color(0xFF5A4EFF)
                    : const Color(0xFF6B6B6B),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}