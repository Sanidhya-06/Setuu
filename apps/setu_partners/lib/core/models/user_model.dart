class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> interests;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.interests,
    required this.location,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'uid':       uid,
    'name':      name,
    'email':     email,
    'interests': interests,
    'location':  location,
    'latitude':  latitude,
    'longitude': longitude,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid:       map['uid'] ?? '',
    name:      map['name'] ?? '',
    email:     map['email'] ?? '',
    interests: List<String>.from(map['interests'] ?? []),
    location:  map['location'] ?? '',
    latitude:  map['latitude']?.toDouble(),
    longitude: map['longitude']?.toDouble(),
    createdAt: DateTime.parse(map['createdAt']),
  );
}