import 'package:flutter/material.dart';
import '../campaign_controller.dart';

class CampaignDetailSheet extends StatelessWidget {
  final Campaign campaign;
  final CampaignController controller;

  const CampaignDetailSheet({
    super.key,
    required this.campaign,
    required this.controller,
  });

  static void show(
      BuildContext context, Campaign campaign, CampaignController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CampaignDetailSheet(
          campaign: campaign, controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = campaign.maxVolunteers > 0
        ? (campaign.joinedCount / campaign.maxVolunteers).clamp(0.0, 1.0)
        : 0.0;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Image
              Padding(
                padding: const EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: campaign.imageUrl.isNotEmpty
                        ? Image.network(campaign.imageUrl, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _imgFallback())
                        : _imgFallback(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: campaign.badgeColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(campaign.badge,
                          style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    Text(campaign.title,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1C),
                        )),
                    const SizedBox(height: 8),
                    Text(campaign.description,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          color: Color(0xFF6B6B6B),
                          height: 1.6,
                        )),
                    const SizedBox(height: 14),
                    _row(Icons.location_on_outlined, campaign.location),
                    const SizedBox(height: 6),
                    _row(Icons.calendar_today_outlined,
                        '${campaign.date}  •  ${campaign.time}'),
                    const SizedBox(height: 6),
                    _row(Icons.category_outlined, campaign.category),
                    const SizedBox(height: 6),
                    _row(Icons.group_outlined,
                        '${campaign.joinedCount}/${campaign.maxVolunteers} volunteers joined'),
                    const SizedBox(height: 14),
                    // Progress bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Volunteer Capacity',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 12,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF5A4EFF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF0EEFF),
                        valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF5A4EFF)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Status change buttons
                    const Text('Change Status',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1C),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Active', 'Upcoming', 'Completed']
                          .map((s) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.updateCampaignStatus(
                                          campaign.id, s);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      decoration: BoxDecoration(
                                        color: campaign.badge == s
                                            ? Campaign.badgeColorForStatus(s)
                                            : const Color(0xFFF5F4FF),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Text(s,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: campaign.badge == s
                                                ? Colors.white
                                                : const Color(0xFF6B6B6B),
                                          )),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Delete
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmDelete(context);
                        },
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: Colors.redAccent, size: 18),
                        label: const Text('Delete Campaign',
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Campaign?',
            style: TextStyle(
                fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
        content: const Text(
            'This action cannot be undone. The campaign will be permanently removed.',
            style: TextStyle(fontFamily: 'Rubik', color: Color(0xFF6B6B6B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    fontFamily: 'Rubik', color: Color(0xFF6B6B6B))),
          ),
          TextButton(
            onPressed: () {
              controller.deleteCampaign(campaign.id);
              Navigator.pop(context);
            },
            child: const Text('Delete',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B6B6B)),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 13,
                    color: Color(0xFF6B6B6B)))),
      ],
    );
  }

  Widget _imgFallback() => Container(
        color: const Color(0xFFEEEBFF),
        child:
            const Icon(Icons.campaign_rounded, color: Color(0xFF5A4EFF), size: 48),
      );
}