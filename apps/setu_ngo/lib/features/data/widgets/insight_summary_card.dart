// lib/widgets/insight_summary_card.dart

import 'package:flutter/material.dart';
import '../models/insight_model.dart';

class InsightSummaryCard extends StatelessWidget {
  final InsightModel insight;
  const InsightSummaryCard({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A3AFF), Color(0xFF8B6FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Insight Snapshot',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _fmt(insight.createdAt),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Kpi(
                label: 'Total Records',
                value: insight.totalRecords.toString(),
                icon: Icons.dataset_outlined,
              ),
              const SizedBox(width: 10),
              _Kpi(
                label: 'Top Issue',
                value: insight.topIssue,
                icon: Icons.priority_high_rounded,
              ),
              const SizedBox(width: 10),
              _Kpi(
                label: 'Top Location',
                value: insight.topLocation,
                icon: Icons.location_on_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.year}-${_p(d.month)}-${_p(d.day)} '
          '${_p(d.hour)}:${_p(d.minute)}';
    } catch (_) {
      return iso;
    }
  }

  String _p(int n) => n.toString().padLeft(2, '0');
}

class _Kpi extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Kpi({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}