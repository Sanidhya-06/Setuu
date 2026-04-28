import 'package:flutter/material.dart';
<<<<<<< HEAD

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data'),
      ),
      body: const Center(
        child: Text(
          'Data Screen Coming Soon',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
=======
import '../models/data_file.dart';
import '../widgets/data_page_header.dart';
import '../widgets/upload_hero_card.dart';
import '../widgets/overview_section.dart';
import '../widgets/data_tab_bar.dart';
import '../widgets/data_file_list_item.dart';
import '../widgets/insights_banner.dart';
import '../widgets/data_bottom_nav_bar.dart';
import 'data_upload_screen.dart';
import 'data_raw_view_screen.dart';
import 'data_insights_screen.dart';
import 'data_analytics_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int _selectedTab = 0;
  int _selectedNav = 2;

  List<DataFile> get _filteredFiles {
    switch (_selectedTab) {
      case 1:
        return DataPageData.files
            .where((f) => f.status == ProcessingStatus.processed)
            .toList();
      default:
        return DataPageData.files;
    }
  }

  void _goToUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DataUploadScreen()),
    );
  }

  void _goToInsights() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DataInsightsScreen()),
    );
  }

  void _goToRawView(DataFile file) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DataRawViewScreen(file: file)),
    );
  }

  void _onNavTap(int index) {
    if (index == 2) {
      setState(() => _selectedNav = index);
      return;
    }
    // Show a snack for unimplemented nav tabs
    final labels = DataPageData.navItems.map((e) => e.label).toList();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${labels[index]} coming soon'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Header
                  const SliverToBoxAdapter(child: DataPageHeader()),

                  // Upload hero
                  SliverToBoxAdapter(
                    child: UploadHeroCard(onUploadTap: _goToUpload),
                  ),

                  // Overview stats
                  SliverToBoxAdapter(
                    child: OverviewSection(stats: DataPageData.stats),
                  ),

                  // Tab bar
                  SliverToBoxAdapter(
                    child: DataTabBar(
                      tabs: DataPageData.tabs,
                      selectedIndex: _selectedTab,
                      onTabSelected: (i) => setState(() => _selectedTab = i),
                    ),
                  ),

                  // Divider
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Divider(color: Color(0xFFE5E5EF), height: 1),
                    ),
                  ),

                  // Search bar
                  const SliverToBoxAdapter(child: DataSearchBar()),
                  const SliverToBoxAdapter(child: SizedBox(height: 14)),

                  // File list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final files = _filteredFiles;
                        if (index >= files.length) return null;
                        return GestureDetector(
                          onTap: () => _goToRawView(files[index]),
                          child: DataFileListItem(file: files[index]),
                        );
                      },
                      childCount: _filteredFiles.length,
                    ),
                  ),

                  // Insights banner
                  SliverToBoxAdapter(
                    child: InsightsBanner(onViewInsights: _goToInsights),
                  ),
                ],
              ),
            ),

            // Bottom nav
            DataBottomNavBar(
              selectedIndex: _selectedNav,
              onItemSelected: _onNavTap,
            ),
          ],
        ),
      ),

      // FAB shortcut to analytics
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C5CE7),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DataAnalyticsScreen()),
        ),
        child: const Icon(Icons.analytics_outlined, color: Colors.white),
      ),
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
    );
  }
}