import 'package:flutter/material.dart';
import '../models/data_file.dart';

class OverviewSection extends StatelessWidget {
  final List<OverviewStat> stats;

  const OverviewSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5EF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Text(
                      'This Month',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4A4A6A),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF4A4A6A),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(stats.length, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < stats.length - 1 ? 10 : 0),
                  child: _StatCard(stat: stats[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final OverviewStat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stat.iconBgColor,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(stat.icon, color: stat.iconColor, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: const TextStyle(
              fontSize: 9.5,
              color: Color(0xFF8A8A9A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.changeText,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xFF00B47E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}