class NgoProfile {
  final String id;
  final String name;
  final String email;
  final String website;
  final String location;
  final String? profileImageUrl;
  final bool isVerified;
  final OrganizationInfo organizationInfo;

  NgoProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.website,
    required this.location,
    this.profileImageUrl,
    required this.isVerified,
    required this.organizationInfo,
  });

  factory NgoProfile.fromJson(Map<String, dynamic> json) {
    return NgoProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      location: json['location'] ?? '',
      profileImageUrl: json['profile_image_url'],
      isVerified: json['is_verified'] ?? false,
      organizationInfo: OrganizationInfo.fromJson(
        json['organization_info'] ?? {},
      ),
    );
  }
}

class OrganizationInfo {
  final String registrationNumber;
  final String establishedYear;
  final String organizationType;
  final String description;
  final String taxExemptionStatus;

  OrganizationInfo({
    required this.registrationNumber,
    required this.establishedYear,
    required this.organizationType,
    required this.description,
    required this.taxExemptionStatus,
  });

  factory OrganizationInfo.fromJson(Map<String, dynamic> json) {
    return OrganizationInfo(
      registrationNumber: json['registration_number'] ?? '',
      establishedYear: json['established_year'] ?? '',
      organizationType: json['organization_type'] ?? '',
      description: json['description'] ?? '',
      taxExemptionStatus: json['tax_exemption_status'] ?? '',
    );
  }
}