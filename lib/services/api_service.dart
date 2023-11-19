import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService with ChangeNotifier {
  static const String nasaApiKey = 'ngOXHGuuogT9Q64YTesONQG2iQDNYFhwtEsxESdG';

  Future<List<Map<String, dynamic>>> fetchAsteroids(int page) async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/neo/rest/v1/neo/browse?page=$page&api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)['near_earth_objects']);
    } else {
      throw Exception('Failed to load asteroids');
    }
  }

  Future<Map<String, dynamic>> fetchAsteroidDetails(String asteroidId) async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/neo/rest/v1/neo/$asteroidId?api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load asteroid details');
    }
  }

  Future<Map<String, dynamic>> fetchClosestApproachInfo(
      String asteroidId) async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/neo/rest/v1/neo/$asteroidId?api_key=$nasaApiKey'));
    if (response.statusCode == 200) {
      final asteroidDetails = json.decode(response.body);

      // Check if closest_approach_data is available
      if (asteroidDetails.containsKey('close_approach_data') &&
          asteroidDetails['close_approach_data'] is List &&
          asteroidDetails['close_approach_data'].isNotEmpty) {
        // Extract the first closest approach data (you may want to iterate if there are multiple entries)
        final closestApproachData = asteroidDetails['close_approach_data'][0];

        // Check if date and relative_velocity are available
        final date = closestApproachData.containsKey('close_approach_date')
            ? closestApproachData['close_approach_date']
            : null;
        final relativeVelocity =
            closestApproachData.containsKey('relative_velocity')
                ? closestApproachData['relative_velocity']
                : null;

        return {
          'date': date,
          'relative_velocity': relativeVelocity,
          // Add more fields as needed
        };
      } else {
        throw Exception(
            'Closest approach data not available for NEO $asteroidId');
      }
    } else {
      throw Exception('Failed to load closest approach information');
    }
  }
}
