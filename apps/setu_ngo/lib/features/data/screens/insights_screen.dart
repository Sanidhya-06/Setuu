// lib/screens/insights_screen.dart

import 'package:flutter/material.dart';
import '../models/insight_model.dart';
import '../services/firestore_service.dart';
import '../widgets/insight_summary_card.dart';
import '../widgets/insight_detail_sheet.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FF),
        elevation: 0,
        title: const Text(
          'Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        actions: [
          StreamBuilder<List<InsightModel>>(
            stream: FirestoreService.instance.insightsStream(),
            builder: (_, snap) {
              final count = snap.data?.length ?? 0;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEBFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count snapshots',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<InsightModel>>(
        stream: FirestoreService.instance.insightsStream(),
        builder: (context, snap) {
          // Loading
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF6C5CE7)),
              ),
            );
          }

          // Error
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off,
                        color: Color(0xFFFF4B4B), size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Firestore connection error',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      snap.error.toString(),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8A8A9A)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final list = snap.data ?? [];

          // Empty state
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEBFF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.insights_outlined,
                      color: Color(0xFF6C5CE7),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No insights yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload a file in the Upload tab.',
                    style: TextStyle(
                        fontSize: 14, color: Color(0xFF8A8A9A)),
                  ),
                ],
              ),
            );
          }

          // List
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final insight = list[i];
              return GestureDetector(
                onTap: () =>
                    InsightDetailSheet.show(context, insight),
                child: Stack(
                  children: [
                    InsightSummaryCard(insight: insight),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right,
                                color: Colors.white, size: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}