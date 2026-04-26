import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final String city;
  final String countryCode;

  const LocationResult({required this.city, required this.countryCode});

  /// Shown as "Mumbai, IN" in the LocationBar.
  static const LocationResult fallback =
      LocationResult(city: 'Mumbai', countryCode: 'IN');
}

/// Resolves the device's current city and ISO country code.
/// Returns [LocationResult.fallback] if permission is denied or any error occurs.
class LocationService {
  Future<LocationResult> resolve() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return LocationResult.fallback;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.fallback;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return LocationResult.fallback;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return LocationResult.fallback;

      final Placemark place = placemarks.first;
      final String city = place.locality?.isNotEmpty == true
          ? place.locality!
          : (place.administrativeArea ?? 'Unknown');
      final String code = place.isoCountryCode ?? '';

      return LocationResult(city: city, countryCode: code);
    } catch (_) {
      return LocationResult.fallback;
    }
  }
}