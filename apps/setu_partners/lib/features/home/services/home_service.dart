import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/featured_campaign.dart';
import '../models/popular_opportunity.dart';

/// All network calls for the Home feature.
/// Replace [baseUrl] with your real API base URL.
class HomeService {
  static const String baseUrl = 'https://your-api.example.com/api/v1';
  static const Duration _timeout = Duration(seconds: 10);

  Future<List<FeaturedCampaign>> fetchFeaturedCampaigns() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/campaigns/featured'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => FeaturedCampaign.fromJson(j)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<PopularOpportunity>> fetchPopularOpportunities() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/campaigns/popular'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => PopularOpportunity.fromJson(j)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}