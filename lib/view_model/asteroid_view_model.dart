import 'package:flutter/foundation.dart';

import '../services/api_service.dart';

class AsteroidViewModel with ChangeNotifier {
  final ApiService apiService;

  AsteroidViewModel({required this.apiService});

  List<Map<String, dynamic>> asteroids = [];
  int currentPage = 1;

  Future<void> fetchAsteroids() async {
    try {
      final newAsteroids = await apiService.fetchAsteroids(currentPage);
      asteroids.addAll(newAsteroids);
      currentPage++;
      notifyListeners();
    } catch (error) {
      // ignore: avoid_print
      print('Error fetching asteroids: $error');
    }
  }
}
