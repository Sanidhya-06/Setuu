import 'package:flutter/material.dart';

class InsightsBanner extends StatelessWidget {
  final VoidCallback onViewInsights;

  const InsightsBanner({super.key, required this.onViewInsights});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEBFF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.pie_chart_outline_rounded,
                color: Color(0xFF6C5CE7),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock Deeper Insights ✨',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Go to Insights to explore trends, patterns and visualizations from your data.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF6A6A8A),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onViewInsights,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Insights',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 11,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}