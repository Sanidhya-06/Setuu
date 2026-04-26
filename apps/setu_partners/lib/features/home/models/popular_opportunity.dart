class PopularOpportunity {
  final String id;
  final String title;
  final String location;
  final String dateRange;
  final String imageUrl;

  /// e.g. 'Most Joined', 'Trending'
  final String badge;
  final bool isSaved;

  const PopularOpportunity({
    required this.id,
    required this.title,
    required this.location,
    required this.dateRange,
    required this.imageUrl,
    required this.badge,
    this.isSaved = false,
  });

  factory PopularOpportunity.fromJson(Map<String, dynamic> json) {
    return PopularOpportunity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      dateRange: json['date_range'] ?? json['dateRange'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      badge: json['badge'] ?? '',
    );
  }
}