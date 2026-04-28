import 'package:flutter/material.dart';
import 'package:setu_partners/features/home/models/category_stat.dart';
import 'package:setu_partners/features/home/models/featured_campaign.dart';
import 'package:setu_partners/features/home/models/popular_opportunity.dart';
import 'package:setu_partners/features/home/models/state_item.dart';
import 'package:setu_partners/features/home/services/home_service.dart';
import 'package:setu_partners/features/home/services/location_service.dart';
import 'package:setu_partners/features/home/widgets/category_grid.dart';
import 'package:setu_partners/features/home/widgets/featured_carousel.dart';
import 'package:setu_partners/features/home/widgets/home_header.dart';
import 'package:setu_partners/features/home/widgets/home_search_bar.dart';
import 'package:setu_partners/features/home/widgets/popular_grid.dart';
import 'package:setu_partners/features/home/widgets/state_row.dart';
import 'package:setu_partners/features/profile/screens/profile_screen.dart';
import '../../discover/screens/discover_screen.dart';
import '../../report/screens/report_issue_screen.dart';
import '../../heatmap/screens/heatmap_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Services ──────────────────────────────────────────────────────────────
  final _homeService = HomeService();
  final _locationService = LocationService();

  // ── Nav ───────────────────────────────────────────────────────────────────
  int _currentNavIndex = 0;
  String? _discoverStateFilter;

  // ── User (populated from your auth service) ───────────────────────────────
  String _userName = '';
  int _notificationCount = 0;

  // ── Location ──────────────────────────────────────────────────────────────
  String _locationCity = 'Locating…';
  String _locationCountry = '';
  bool _locationLoading = true;

  // ── Campaigns ─────────────────────────────────────────────────────────────
  bool _isLoading = true;
  String? _errorMessage;
  List<FeaturedCampaign> _featuredCampaigns = [];
  List<PopularOpportunity> _popularOpportunities = [];

  // ── Static data ───────────────────────────────────────────────────────────
  static const List<CategoryStat> _categories = [
    CategoryStat(
      id: 'education',
      label: 'Education',
      icon: Icons.volunteer_activism,
      bgColor: Color(0xFFEEEBFF),
      iconColor: Color(0xFF6B4EFF),
      programCount: 128,
    ),
    CategoryStat(
      id: 'environment',
      label: 'Environment',
      icon: Icons.eco,
      bgColor: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
      programCount: 96,
    ),
    CategoryStat(
      id: 'health',
      label: 'Health',
      icon: Icons.favorite,
      bgColor: Color(0xFFFFF3E0),
      iconColor: Color(0xFFE53935),
      programCount: 74,
    ),
    CategoryStat(
      id: 'community',
      label: 'Community',
      icon: Icons.group,
      bgColor: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1565C0),
      programCount: 102,
    ),
  ];

  static const List<StateItem> _states = [
    StateItem(
      name: 'Maharashtra',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Gateway_of_India_2008.jpg/320px-Gateway_of_India_2008.jpg',
    ),
    StateItem(
      name: 'Karnataka',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mysore_Palace_in_Mysore.jpg/320px-Mysore_Palace_in_Mysore.jpg',
    ),
    StateItem(
      name: 'Tamil Nadu',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Brihadeeswarar_Temple_1.jpg/320px-Brihadeeswarar_Temple_1.jpg',
    ),
    StateItem(
      name: 'Kerala',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Kerala_backwater_2.jpg/320px-Kerala_backwater_2.jpg',
    ),
    StateItem(
      name: 'Rajasthan',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Hawa_Mahal_Jaipur_Rajasthan_India.jpg/320px-Hawa_Mahal_Jaipur_Rajasthan_India.jpg',
    ),
    StateItem(
      name: 'Gujarat',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/India_Gate_in_New_Delhi_03-2016.jpg/320px-India_Gate_in_New_Delhi_03-2016.jpg',
    ),
  ];

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadUser();
    _fetchCampaigns();
    _fetchLocation();
  }

  // ── Data fetching ─────────────────────────────────────────────────────────

  void _loadUser() {
    // Replace with your auth service — e.g. FirebaseAuth, Supabase, SharedPrefs
    // Example for Firebase:
    //   final user = FirebaseAuth.instance.currentUser;
    //   setState(() {
    //     _userName = user?.displayName?.split(' ').first ?? 'there';
    //     _notificationCount = 0; // fetch from your notifications service
    //   });
    setState(() {
      _userName = 'there'; // fallback until auth is wired
      _notificationCount = 0;
    });
  }

  Future<void> _fetchLocation() async {
    final result = await _locationService.resolve();
    if (mounted) {
      setState(() {
        _locationCity = result.city;
        _locationCountry = result.countryCode;
        _locationLoading = false;
      });
    }
  }

  Future<void> _fetchCampaigns() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _homeService.fetchFeaturedCampaigns(),
        _homeService.fetchPopularOpportunities(),
      ]);

      if (mounted) {
        setState(() {
          _featuredCampaigns = results[0] as List<FeaturedCampaign>;
          _popularOpportunities = results[1] as List<PopularOpportunity>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load campaigns. Please try again.';
        });
      }
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _navigateToDiscover({String? stateFilter}) {
    setState(() {
      _discoverStateFilter = stateFilter;
      _currentNavIndex = 1;
    });
  }

  void _openProfile() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const ProfileScreen()),
  );
}

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(child: _getScreen()),
    );
  }

  Widget _getScreen() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return DiscoverScreen(stateFilter: _discoverStateFilter);
      case 2:
        return const ReportIssueScreen();
      case 3:
        return const HeatmapScreen();
      case 4:
        return const ProfileScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _fetchCampaigns,
      color: const Color(0xFF6B4EFF),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeader(
              userName: _userName,
              notificationCount: _notificationCount,
              locationCity: _locationCity,
              locationCountry: _locationCountry,
              locationLoading: _locationLoading,
              onAvatarTap: _openProfile,
              onLocationTap: () {/* TODO: location picker */},
            ),
          ),
          SliverToBoxAdapter(
            child: FeaturedCarousel(
              campaigns: _featuredCampaigns,
              isLoading: _isLoading,
            ),
          ),
          SliverToBoxAdapter(
            child: HomeSearchBar(
              onTap: () {/* TODO: open search screen */},
            ),
          ),
          SliverToBoxAdapter(
            child: CategoryGrid(
              categories: _categories,
              onTap: (cat) {/* TODO: filter by category */},
            ),
          ),
          SliverToBoxAdapter(
            child: StateRow(
              states: _states,
              onStateTap: (state) =>
                  _navigateToDiscover(stateFilter: state.name),
              onSeeAll: () => _navigateToDiscover(),
            ),
          ),
          SliverToBoxAdapter(
            child: PopularGrid(
              opportunities: _popularOpportunities,
              isLoading: _isLoading,
              errorMessage: _errorMessage,
              onRetry: _fetchCampaigns,
              onSeeAll: () => _navigateToDiscover(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── Bottom nav ────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return NavigationBar(
      selectedIndex: _currentNavIndex,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFEEEBFF),
      onDestinationSelected: (index) =>
          setState(() => _currentNavIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home, color: Color(0xFF6B4EFF)),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore, color: Color(0xFF6B4EFF)),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline, size: 28),
          selectedIcon:
              Icon(Icons.add_circle, size: 28, color: Color(0xFF6B4EFF)),
          label: '',
        ),
        NavigationDestination(
          icon: Icon(Icons.map),
          selectedIcon:
              Icon(Icons.map, color: Color(0xFF6B4EFF)),
          label: 'HeatMap',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person, color: Color(0xFF6B4EFF)),
          label: 'Profile',
        ),
      ],
    );
  }
}