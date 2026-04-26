class FeaturedCampaign {
  final String id;
  final String title;
  final String subtitle;
  final String location;
  final String dateRange;
  final String imageUrl;
  final int participantCount;
  final List<String> participantAvatars;

  const FeaturedCampaign({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.dateRange,
    required this.imageUrl,
    required this.participantCount,
    required this.participantAvatars,
  });

  factory FeaturedCampaign.fromJson(Map<String, dynamic> json) {
    return FeaturedCampaign(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? json['description'] ?? '',
      location: json['location'] ?? '',
      dateRange: json['date_range'] ?? json['dateRange'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      participantCount:
          json['participant_count'] ?? json['participantCount'] ?? 0,
      participantAvatars: List<String>.from(
        json['participant_avatars'] ?? json['participantAvatars'] ?? [],
      ),
    );
  }
}