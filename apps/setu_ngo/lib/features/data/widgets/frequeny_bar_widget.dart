// lib/widgets/frequency_bar_widget.dart

import 'package:flutter/material.dart';

class FrequencyBarWidget extends StatelessWidget {
  final String title;
  final Map<String, int> data;
  final Color barColor;

  const FrequencyBarWidget({
    super.key,
    required this.title,
    required this.data,
    this.barColor = const Color(0xFF6C5CE7),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _wrap(child: const Text(
        'No data',
        style: TextStyle(color: Color(0xFF8A8A9A)),
      ));
    }

    final maxVal = data.values.reduce((a, b) => a > b ? a : b);
    final sorted = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return _wrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: sorted
            .map((e) => _BarRow(
                  label: e.key,
                  value: e.value,
                  maxValue: maxVal,
                  color: barColor,
                ))
            .toList(),
      ),
    );
  }

  Widget _wrap({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  const _BarRow({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final frac = maxValue == 0 ? 0.0 : value / maxValue;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A4A6A),
                  ),
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(builder: (_, c) {
            return Stack(children: [
              Container(
                height: 7,
                width: c.maxWidth,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 7,
                width: c.maxWidth * frac,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ]);
          }),
        ],
      ),
    );
  }
}