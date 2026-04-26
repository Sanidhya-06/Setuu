import 'package:flutter/material.dart';
import '../campaign_controller.dart';
import '../widgets/campaign_card.dart';
import 'create_campaign.dart';
import 'campaign_details.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen>
    with SingleTickerProviderStateMixin {
  final _controller = CampaignController();
  final _searchController = TextEditingController();
  bool _showSearch = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _controller.tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _controller.setTab(_controller.tabs[_tabController.index]);
      }
    });
    _controller.fetchCampaigns();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openCreateCampaign() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateCampaignScreen(controller: _controller),
      ),
    );
    // Campaign list already refreshed inside createCampaign()
  }

  void _showCampaignMenu(Campaign campaign) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2)),
            ),
            ListTile(
              leading: const Icon(Icons.visibility_outlined,
                  color: Color(0xFF5A4EFF)),
              title: const Text('View Details',
                  style: TextStyle(fontFamily: 'Rubik')),
              onTap: () {
                Navigator.pop(context);
                CampaignDetailSheet.show(context, campaign, _controller);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline,
                  color: Color(0xFF22C55E)),
              title: const Text('Mark as Active',
                  style: TextStyle(fontFamily: 'Rubik')),
              onTap: () {
                _controller.updateCampaignStatus(campaign.id, 'Active');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule_outlined,
                  color: Color(0xFF5A4EFF)),
              title: const Text('Mark as Upcoming',
                  style: TextStyle(fontFamily: 'Rubik')),
              onTap: () {
                _controller.updateCampaignStatus(campaign.id, 'Upcoming');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.done_all_rounded, color: Color(0xFF9CA3AF)),
              title: const Text('Mark as Completed',
                  style: TextStyle(fontFamily: 'Rubik')),
              onTap: () {
                _controller.updateCampaignStatus(campaign.id, 'Completed');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              title: const Text('Delete Campaign',
                  style: TextStyle(
                      fontFamily: 'Rubik', color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(campaign);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(Campaign campaign) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Campaign?',
            style:
                TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
        content: const Text(
            'This will permanently remove the campaign. This action cannot be undone.',
            style:
                TextStyle(fontFamily: 'Rubik', color: Color(0xFF6B6B6B))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    fontFamily: 'Rubik', color: Color(0xFF6B6B6B))),
          ),
          TextButton(
            onPressed: () {
              _controller.deleteCampaign(campaign.id);
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F4FF),
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (_, __) => [
                // ── App Bar ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Campaigns',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1C1C1C),
                                ),
                              ),
                              const Text(
                                'Create, manage and track your campaigns',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 13,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Notification bell
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: _controller.clearNotifications,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.notifications_outlined,
                                    color: Color(0xFF1C1C1C), size: 22),
                              ),
                            ),
                            if (_controller.notificationCount > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${_controller.notificationCount}',
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Tabs ─────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelPadding:
                          const EdgeInsets.only(right: 24, bottom: 8),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(
                            color: Color(0xFF5A4EFF), width: 2.5),
                      ),
                      labelStyle: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      labelColor: const Color(0xFF5A4EFF),
                      unselectedLabelColor: const Color(0xFF6B6B6B),
                      tabs: _controller.tabs
                          .map((t) => _buildTab(t))
                          .toList(),
                    ),
                  ),
                ),

                // ── Create Campaign Banner ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A4EFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: const Icon(Icons.add_rounded,
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create New Campaign',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Start a new campaign and invite volunteers\nto make an impact',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 11,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _openCreateCampaign,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add_rounded,
                                      color: Color(0xFF5A4EFF), size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Create Campaign',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF5A4EFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Count + Search + Filter ──────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Text(
                          'Campaigns (${_controller.filteredCampaigns.length})',
                          style: const TextStyle(
                            fontFamily: 'Rubik',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C1C1C),
                          ),
                        ),
                        const Spacer(),
                        // Search button
                        GestureDetector(
                          onTap: () =>
                              setState(() => _showSearch = !_showSearch),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: const Icon(Icons.search_rounded,
                                color: Color(0xFF6B6B6B), size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Filter button
                        GestureDetector(
                          onTap: () {}, // Hook up filter sheet as needed
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.filter_list_rounded,
                                    color: Color(0xFF5A4EFF), size: 16),
                                SizedBox(width: 6),
                                Text(
                                  'Filter',
                                  style: TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5A4EFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search Bar (animated) ───────────────────────────────
                if (_showSearch)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                            )
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _controller.updateSearch,
                          autofocus: true,
                          style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Color(0xFF1C1C1C)),
                          decoration: const InputDecoration(
                            hintText: 'Search campaigns...',
                            hintStyle: TextStyle(
                                fontFamily: 'Rubik',
                                color: Color(0xFF6B6B6B)),
                            prefixIcon: Icon(Icons.search_rounded,
                                color: Color(0xFF6B6B6B), size: 20),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              body: _buildBody(),
            ),
          ),

          // ── FAB ─────────────────────────────────────────────────────────
          floatingActionButton: FloatingActionButton(
            onPressed: _openCreateCampaign,
            backgroundColor: const Color(0xFF5A4EFF),
            child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5A4EFF)),
      );
    }

    if (_controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFF6B6B6B), size: 48),
              const SizedBox(height: 16),
              Text(_controller.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Rubik', color: Color(0xFF6B6B6B))),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _controller.fetchCampaigns,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5A4EFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Retry',
                    style: TextStyle(fontFamily: 'Rubik')),
              ),
            ],
          ),
        ),
      );
    }

    final campaigns = _controller.filteredCampaigns;

    if (campaigns.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign_outlined,
                size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No campaigns found',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 16,
                    color: Color(0xFF6B6B6B))),
            const SizedBox(height: 8),
            const Text('Create your first campaign to get started',
                style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 13,
                    color: Color(0xFFAAAAAA))),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _openCreateCampaign,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Create Campaign',
                  style: TextStyle(fontFamily: 'Rubik')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A4EFF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        ...campaigns.map((c) => CampaignCard(
              campaign: c,
              onTap: () => CampaignDetailSheet.show(context, c, _controller),
              onMenuTap: () => _showCampaignMenu(c),
            )),
        // View All button
        if (campaigns.length >= 4)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: GestureDetector(
              onTap: () => _controller.setTab('All Campaigns'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View All Campaigns',
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5A4EFF),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF5A4EFF), size: 18),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTab(String label) {
    final dot = _dotColor(label);
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (dot != null) ...[
            const SizedBox(width: 5),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }

  Color? _dotColor(String tab) {
    switch (tab) {
      case 'Active':
        return const Color(0xFF22C55E);
      case 'Upcoming':
        return const Color(0xFF5A4EFF);
      case 'Completed':
        return const Color(0xFF9CA3AF);
      default:
        return null;
    }
  }
}