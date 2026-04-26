import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ngo_profile_model.dart';

class ProfileService {
  static const String _baseUrl = 'https://your-api-base-url.com/api'; // Replace with your API base URL

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<NgoProfile> fetchProfile() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/ngo/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NgoProfile.fromJson(data);
    } else {
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    final token = await _getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/ngo/profile/image'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      await http.MultipartFile.fromPath('profile_image', imageFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['profile_image_url'];
    } else {
      throw Exception('Failed to upload image: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final token = await _getToken();
    try {
      await http.post(
        Uri.parse('$_baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }
}