// lib/services/processing_service.dart

import '../models/insight_model.dart';

class ProcessingService {
  ProcessingService._();
  static final ProcessingService instance = ProcessingService._();

  InsightModel generateInsights(List<Map<String, dynamic>> rows) {
    final categories = <String, int>{};
    final trends = <String, int>{};
    final locations = <String, int>{};

    for (final row in rows) {
      final cat = _str(row, 'category');
      final date = _normaliseDate(_str(row, 'date'));
      final loc = _str(row, 'location');

      categories[cat] = (categories[cat] ?? 0) + 1;
      trends[date] = (trends[date] ?? 0) + 1;
      locations[loc] = (locations[loc] ?? 0) + 1;
    }

    return InsightModel(
      totalRecords: rows.length,
      categories: categories,
      trends: trends,
      locations: locations,
      topIssue: _top(categories),
      topLocation: _top(locations),
      createdAt: DateTime.now().toUtc().toIso8601String(),
    );
  }

  String _str(Map<String, dynamic> row, String key) {
    final v = row[key]?.toString().trim() ?? '';
    return v.isEmpty ? 'Unknown' : v;
  }

  String _normaliseDate(String raw) {
    if (raw == 'Unknown') return raw;
    if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(raw)) return raw.substring(0, 10);
    final parts = raw.split(RegExp(r'[/\-\.]'));
    if (parts.length == 3) {
      final nums = parts.map(int.tryParse).toList();
      if (nums.every((n) => n != null)) {
        final p0 = nums[0]!, p1 = nums[1]!, p2 = nums[2]!;
        if (p0 > 31) {
          return '${p0.toString().padLeft(4, '0')}-'
              '${p1.toString().padLeft(2, '0')}-'
              '${p2.toString().padLeft(2, '0')}';
        }
        return '${p2.toString().padLeft(4, '0')}-'
            '${p1.toString().padLeft(2, '0')}-'
            '${p0.toString().padLeft(2, '0')}';
      }
    }
    return raw;
  }

  String _top(Map<String, int> freq) {
    if (freq.isEmpty) return 'N/A';
    return freq.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}