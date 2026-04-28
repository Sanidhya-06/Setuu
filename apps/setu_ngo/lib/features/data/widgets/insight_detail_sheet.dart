// lib/widgets/insight_detail_sheet.dart

import 'package:flutter/material.dart';
import '../models/insight_model.dart';
import 'frequency_bar_widget.dart';
import 'insight_summary_card.dart';

class InsightDetailSheet extends StatelessWidget {
  final InsightModel insight;
  const InsightDetailSheet({super.key, required this.insight});

  static void show(BuildContext context, InsightModel insight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InsightDetailSheet(insight: insight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F7FF),
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Full Breakdown',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.all(20),
                children: [
                  InsightSummaryCard(insight: insight),
                  const SizedBox(height: 4),
                  FrequencyBarWidget(
                    title: 'Categories',
                    data: insight.categories,
                    barColor: const Color(0xFF6C5CE7),
                  ),
                  FrequencyBarWidget(
                    title: 'Trends (by Date)',
                    data: insight.trends,
                    barColor: const Color(0xFF00B47E),
                  ),
                  FrequencyBarWidget(
                    title: 'Locations',
                    data: insight.locations,
                    barColor: const Color(0xFFFF8C00),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}