import 'package:flutter/material.dart';
<<<<<<< HEAD

class DataInsightsScreen extends StatelessWidget {
  const DataInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Insights'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Data Insights Under Work 📊',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
=======
import '../models/data_file.dart';

class DataInsightsScreen extends StatefulWidget {
  const DataInsightsScreen({super.key});

  @override
  State<DataInsightsScreen> createState() => _DataInsightsScreenState();
}

class _DataInsightsScreenState extends State<DataInsightsScreen> {
  int _selectedFilter = 0;

  static const List<String> _filters = [
    'All',
    'Trends',
    'Alerts',
    'Positive',
    'Efficiency',
  ];

  List<InsightItem> get _filteredInsights {
    if (_selectedFilter == 0) return DataPageData.insights;
    final tag = _filters[_selectedFilter];
    return DataPageData.insights.where((i) => i.tag == tag).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FF),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
        title: const Text(
          'Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero summary
          _InsightsSummaryHero(),

          const SizedBox(height: 20),

          // Filter chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected = _selectedFilter == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF6C5CE7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFFE5E5EF),
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : const Color(0xFF4A4A6A),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Insight cards
          Expanded(
            child: _filteredInsights.isEmpty
                ? const Center(
                    child: Text(
                      'No insights for this filter.',
                      style: TextStyle(color: Color(0xFF8A8A9A)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _filteredInsights.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, i) =>
                        _InsightCard(item: _filteredInsights[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _InsightsSummaryHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF3A2ECC), Color(0xFF9B87FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '24 Insights Generated',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'From 5 datasets · Updated today',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _HeroBadge(label: '4 Alerts', color: Color(0xFFFF6B6B)),
                      SizedBox(width: 8),
                      _HeroBadge(
                          label: '12 Trends',
                          color: Color(0xFF00D4AA)),
                      SizedBox(width: 8),
                      _HeroBadge(
                          label: '8 Tips', color: Color(0xFFFFB347)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.insights, color: Colors.white54, size: 56),
          ],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _HeroBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final InsightItem item;

  const _InsightCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.tagColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.tag,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item.tagColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6A6A8A),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFB0B0C0),
                  ),
                ),
              ],
            ),
          ),
        ],
>>>>>>> f1522c9 (upload screen+  firebase + analytics)
      ),
    );
  }
}