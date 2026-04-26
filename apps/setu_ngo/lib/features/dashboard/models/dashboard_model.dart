class DashboardModel {
  final int campaigns;
  final int volunteers;
  final int reports;
  final int impactScore;

  DashboardModel({
    required this.campaigns,
    required this.volunteers,
    required this.reports,
    required this.impactScore,
  });

  factory DashboardModel.fromMap(Map<String, dynamic> data) {
    return DashboardModel(
      campaigns: data['totalCampaigns'] ?? 0,
      volunteers: data['totalVolunteers'] ?? 0,
      reports: data['totalReports'] ?? 0,
      impactScore: data['impactScore'] ?? 0,
    );
  }
}