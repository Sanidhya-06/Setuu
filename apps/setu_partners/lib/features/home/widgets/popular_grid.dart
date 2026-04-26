import 'package:flutter/material.dart';
import '../models/popular_opportunity.dart';

class PopularGrid extends StatelessWidget {
  final List<PopularOpportunity> opportunities;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final VoidCallback onSeeAll;

  const PopularGrid({
    super.key,
    required this.opportunities,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Opportunities',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0D0D0D),
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B4EFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(
            color: Color(0xFF6B4EFF), strokeWidth: 2),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text(errorMessage!,
                style: const TextStyle(color: Color(0xFF7A7A7A))),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry',
                  style: TextStyle(color: Color(0xFF6B4EFF))),
            ),
          ],
        ),
      );
    }

    if (opportunities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 48, color: Color(0xFFD1CBF9)),
            SizedBox(height: 12),
            Text(
              'No campaigns available right now.',
              style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Check back soon for new opportunities!',
              style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: opportunities.length,
        itemBuilder: (_, index) =>
            _OpportunityCard(opp: opportunities[index]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private card
// ---------------------------------------------------------------------------

class _OpportunityCard extends StatelessWidget {
  final PopularOpportunity opp;

  const _OpportunityCard({required this.opp});

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = opp.badge == 'Trending'
        ? const Color(0xFF00B894)
        : const Color(0xFF6B4EFF);

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: opp.imageUrl.isNotEmpty
                        ? Image.network(
                            opp.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(color: const Color(0xFFEEEBFF)),
                          )
                        : Container(color: const Color(0xFFEEEBFF)),
                  ),
                  if (opp.badge.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          opp.badge,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          opp.title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D0D0D),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.favorite_border,
                          size: 16, color: Color(0xFF7A7A7A)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  _IconText(
                      icon: Icons.location_on_outlined, text: opp.location),
                  const SizedBox(height: 2),
                  _IconText(
                      icon: Icons.calendar_today_outlined,
                      text: opp.dateRange),
                ],
              ),
            ),
          ],
        ),
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
            style:
                const TextStyle(fontSize: 11, color: Color(0xFF7A7A7A)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}