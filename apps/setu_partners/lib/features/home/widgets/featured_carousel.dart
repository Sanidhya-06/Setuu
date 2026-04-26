import 'package:flutter/material.dart';
import '../models/featured_campaign.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<FeaturedCampaign> campaigns;
  final bool isLoading;

  const FeaturedCarousel({
    super.key,
    required this.campaigns,
    required this.isLoading,
  });

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildSkeleton();
    if (widget.campaigns.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.campaigns.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _FeaturedCard(campaign: widget.campaigns[index]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.campaigns.length, (i) {
            final selected = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: selected ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF6B4EFF)
                    : const Color(0xFFD1CBF9),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6B4EFF),
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private card — used only inside this file
// ---------------------------------------------------------------------------

class _FeaturedCard extends StatelessWidget {
  final FeaturedCampaign campaign;

  const _FeaturedCard({required this.campaign});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'FEATURED OPPORTUNITY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B4EFF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D0D0D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    campaign.subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF7A7A7A)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _IconText(
                      icon: Icons.location_on_outlined,
                      text: campaign.location),
                  const SizedBox(height: 4),
                  _IconText(
                      icon: Icons.calendar_today_outlined,
                      text: campaign.dateRange),
                  const SizedBox(height: 12),
                  _ParticipantRow(campaign: campaign),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4EFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('View Details'),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (campaign.imageUrl.isNotEmpty)
            SizedBox(
              width: 130,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      campaign.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: const Color(0xFFEEEBFF)),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Color(0xFF0D0D0D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;

  const _IconText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: const Color(0xFF7A7A7A)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11, color: Color(0xFF7A7A7A)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final FeaturedCampaign campaign;

  const _ParticipantRow({required this.campaign});

  @override
  Widget build(BuildContext context) {
    const double size = 24;
    final avatars = campaign.participantAvatars.take(3).toList();
    final extra = campaign.participantCount - avatars.length;

    return Row(
      children: [
        SizedBox(
          width: size + (avatars.length - 1) * (size * 0.6),
          height: size,
          child: Stack(
            children: List.generate(avatars.length, (i) {
              return Positioned(
                left: i * size * 0.6,
                child: CircleAvatar(
                  radius: size / 2,
                  backgroundImage: NetworkImage(avatars[i]),
                  backgroundColor: Colors.grey.shade200,
                ),
              );
            }),
          ),
        ),
        if (extra > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF6B4EFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+$extra',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}