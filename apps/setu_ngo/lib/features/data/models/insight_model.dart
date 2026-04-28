// lib/models/insight_model.dart

class InsightModel {
  final String? id;
  final int totalRecords;
  final Map<String, int> categories;
  final Map<String, int> trends;
  final Map<String, int> locations;
  final String topIssue;
  final String topLocation;
  final String createdAt;

  const InsightModel({
    this.id,
    required this.totalRecords,
    required this.categories,
    required this.trends,
    required this.locations,
    required this.topIssue,
    required this.topLocation,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'totalRecords': totalRecords,
        'categories': categories,
        'trends': trends,
        'locations': locations,
        'topIssue': topIssue,
        'topLocation': topLocation,
        'createdAt': createdAt,
      };

  factory InsightModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return InsightModel(
      id: id,
      totalRecords: (map['totalRecords'] as num?)?.toInt() ?? 0,
      categories: _toIntMap(map['categories']),
      trends: _toIntMap(map['trends']),
      locations: _toIntMap(map['locations']),
      topIssue: (map['topIssue'] as String?) ?? '',
      topLocation: (map['topLocation'] as String?) ?? '',
      createdAt: (map['createdAt'] as String?) ?? '',
    );
  }

  static Map<String, int> _toIntMap(dynamic raw) {
    if (raw == null) return {};
    return (raw as Map<dynamic, dynamic>)
        .map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
  }
}