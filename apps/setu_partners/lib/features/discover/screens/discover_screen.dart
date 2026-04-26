import 'package:flutter/material.dart';
import '../discover_controller.dart';
import '../widgets/campaign_list.dart';
import '../widgets/filter_chip.dart';

class DiscoverScreen extends StatefulWidget {
  /// When set (e.g. tapped from Home → "Explore by State"),
  /// the screen pre-selects this state in the controller.
  final String? stateFilter;

  const DiscoverScreen({super.key, this.stateFilter});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _controller = DiscoverController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.fetchAll().then((_) {
      // After data loads, apply the incoming state filter (if any).
      if (widget.stateFilter != null && widget.stateFilter!.isNotEmpty) {
        _controller.setState_(widget.stateFilter!);
      }
    });
  }

  @override
  void didUpdateWidget(DiscoverScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-apply if parent pushes a new filter while already on this tab.
    if (widget.stateFilter != oldWidget.stateFilter &&
        widget.stateFilter != null) {
      _controller.setState_(widget.stateFilter!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showCampaignDetail(Campaign campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: campaign.imageUrl.isNotEmpty
                          ? Image.network(campaign.imageUrl, fit: BoxFit.cover)
                          : Container(color: const Color(0xFFEEEBFF)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (campaign.badge.isNotEmpty)
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
                      Text(
                        campaign.title,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        campaign.description,
                        style: const TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 14,
                          color: Color(0xFF6B6B6B),
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _detailRow(Icons.location_on_outlined, campaign.location),
                      const SizedBox(height: 6),
                      _detailRow(Icons.calendar_today_outlined, campaign.date),
                      const SizedBox(height: 6),
                      _detailRow(Icons.category_outlined, campaign.category),
                      const SizedBox(height: 6),
                      _detailRow(Icons.group_outlined,
                          '${campaign.joinedCount} volunteers joined'),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A4EFF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Apply Now',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetail(UpcomingEvent event) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: event.imageUrl.isNotEmpty
                    ? Image.network(event.imageUrl, fit: BoxFit.cover)
                    : Container(color: const Color(0xFFEEEBFF)),
              ),
            ),
            const SizedBox(height: 16),
            Text(event.title,
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(event.description,
                style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    color: Color(0xFF6B6B6B),
                    height: 1.5)),
            const SizedBox(height: 10),
            _detailRow(Icons.location_on_outlined, event.location),
            const SizedBox(height: 6),
            _detailRow(Icons.access_time_outlined, event.timeRange),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A4EFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Register',
                    style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B6B6B)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 13,
                  color: Color(0xFF6B6B6B))),
        ),
      ],
    );
  }

  void _showStatePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Filter by State',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ListTile(
              leading:
                  const Icon(Icons.public_rounded, color: Color(0xFF5A4EFF)),
              title:
                  const Text('All States', style: TextStyle(fontFamily: 'Rubik')),
              trailing: _controller.selectedState == 'All'
                  ? const Icon(Icons.check_rounded, color: Color(0xFF5A4EFF))
                  : null,
              onTap: () {
                _controller.setState_('All');
                Navigator.pop(context);
              },
            ),
            ..._controller.states.map(
              (s) => ListTile(
                leading: ClipOval(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: s.imageUrl.isNotEmpty
                        ? Image.network(s.imageUrl, fit: BoxFit.cover)
                        : Container(color: const Color(0xFFEEEBFF)),
                  ),
                ),
                title: Text(s.name, style: const TextStyle(fontFamily: 'Rubik')),
                trailing: _controller.selectedState == s.name
                    ? const Icon(Icons.check_rounded, color: Color(0xFF5A4EFF))
                    : null,
                onTap: () {
                  _controller.setState_(s.name);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F4FF),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Location + Search ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: _showStatePicker,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded,
                                          color: Color(0xFF5A4EFF), size: 18),
                                      const SizedBox(width: 8),
                                      Text(
                                        _controller.selectedState == 'All'
                                            ? 'All States'
                                            : _controller.selectedState,
                                        style: const TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1C1C1C),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          size: 18,
                                          color: Color(0xFF1C1C1C)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _showStatePicker,
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.tune_rounded,
                                    color: Color(0xFF5A4EFF), size: 20),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search_rounded,
                                  color: Color(0xFF6B6B6B), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _controller.updateSearch,
                                  style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 14,
                                      color: Color(0xFF1C1C1C)),
                                  decoration: const InputDecoration(
                                    hintText: 'Search programs or causes...',
                                    hintStyle: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 14,
                                        color: Color(0xFF6B6B6B)),
                                    border: InputBorder.none,
                                    isDense: true,
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

                // ── Explore by State ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Explore by State',
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1C1C))),
                        GestureDetector(
                          onTap: _showStatePicker,
                          child: const Text('See All',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5A4EFF))),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: _controller.loadingStates
                      ? const SizedBox(
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF5A4EFF)),
                          ),
                        )
                      : SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding:
                                const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            itemCount: _controller.states.length,
                            itemBuilder: (_, i) {
                              final s = _controller.states[i];
                              return GestureDetector(
                                onTap: () => _controller.setState_(s.name),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _controller.selectedState ==
                                                    s.name
                                                ? const Color(0xFF5A4EFF)
                                                : s.borderColor,
                                            width: 2.5,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: s.imageUrl.isNotEmpty
                                              ? Image.network(s.imageUrl,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          _stateIconFallback())
                                              : _stateIconFallback(),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(s.name,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontSize: 11,
                                            fontWeight:
                                                _controller.selectedState ==
                                                        s.name
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                            color: _controller.selectedState ==
                                                    s.name
                                                ? const Color(0xFF5A4EFF)
                                                : const Color(0xFF1C1C1C),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),

                // ── Popular Opportunities ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Popular Opportunities',
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1C1C))),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('See All',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5A4EFF))),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      itemCount: _controller.filterChips.length,
                      itemBuilder: (_, i) {
                        final f = _controller.filterChips[i];
                        return DiscoverFilterChip(
                          label: f,
                          isSelected: _controller.selectedFilter == f,
                          onTap: () => _controller.setFilter(f),
                        );
                      },
                    ),
                  ),
                ),

                if (_controller.loadingCampaigns)
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF5A4EFF)),
                      ),
                    ),
                  )
                else if (_controller.campaignsError != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.wifi_off_rounded,
                              color: Color(0xFF6B6B6B), size: 40),
                          const SizedBox(height: 12),
                          Text(_controller.campaignsError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  color: Color(0xFF6B6B6B))),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _controller.fetchCampaigns,
                            child: const Text('Retry',
                                style: TextStyle(
                                    fontFamily: 'Rubik',
                                    color: Color(0xFF5A4EFF),
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_controller.filteredCampaigns.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(Icons.search_off_rounded,
                              color: Color(0xFF6B6B6B), size: 40),
                          SizedBox(height: 12),
                          Text('No campaigns found',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  color: Color(0xFF6B6B6B))),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final c = _controller.filteredCampaigns[i];
                          return CampaignListCard(
                            campaign: c,
                            isSaved: _controller.isSaved(c.id),
                            onSave: () => _controller.toggleSave(c.id),
                            onTap: () => _showCampaignDetail(c),
                          );
                        },
                        childCount: _controller.filteredCampaigns.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.62,
                      ),
                    ),
                  ),

                // ── Upcoming Events ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Upcoming Events',
                            style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1C1C))),
                        GestureDetector(
                          onTap: () {},
                          child: const Text('See All',
                              style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF5A4EFF))),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_controller.loadingEvents)
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF5A4EFF)),
                      ),
                    ),
                  )
                else if (_controller.events.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('No upcoming events',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Rubik',
                              color: Color(0xFF6B6B6B))),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final e = _controller.events[i];
                          return UpcomingEventCard(
                            event: e,
                            isSaved: _controller.isSaved(e.id),
                            onSave: () {
                              _controller.toggleSave(e.id);
                              _controller.saveEventToFirestore(e.id);
                            },
                            onTap: () => _showEventDetail(e),
                          );
                        },
                        childCount: _controller.events.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stateIconFallback() {
    return Container(
      color: const Color(0xFFEEEBFF),
      child: const Icon(Icons.location_city_rounded, color: Color(0xFF5A4EFF)),
    );
  }
}