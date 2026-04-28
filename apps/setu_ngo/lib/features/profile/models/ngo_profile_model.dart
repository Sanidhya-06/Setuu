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
    final address = json['address'] ?? '';
    final city = json['city'] ?? '';
    final state = json['state'] ?? '';

    String location = [address, city, state]
        .where((s) => s.toString().isNotEmpty)
        .join(', ');

    return NgoProfile(
      id: json['uid'] ?? '',
      name: json['ngoName'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      location: location,
      profileImageUrl: json['profileImageUrl'],
      isVerified: json['registrationStatus'] == 'approved',
      organizationInfo: OrganizationInfo.fromJson(json),
    );
  }
}

class OrganizationInfo {
  final String registrationNumber;
  final String establishedYear;
  final String organizationType;
  final String description;
  final String taxExemptionStatus;
  final String phoneNumber;
  final String pincode;
  final String registrationStatus;

  OrganizationInfo({
    required this.registrationNumber,
    required this.establishedYear,
    required this.organizationType,
    required this.description,
    required this.taxExemptionStatus,
    required this.phoneNumber,
    required this.pincode,
    required this.registrationStatus,
  });

  factory OrganizationInfo.fromJson(Map<String, dynamic> json) {
    return OrganizationInfo(
      registrationNumber: json['registrationNumber'] ?? '',
      establishedYear: json['yearOfEstablishment'] ?? '',
      organizationType: json['ngoType'] ?? '',
      description: json['description'] ?? '',
      taxExemptionStatus: json['registrationStatus'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      pincode: json['pincode'] ?? '',
      registrationStatus: json['registrationStatus'] ?? 'pending',
    );
  }
}