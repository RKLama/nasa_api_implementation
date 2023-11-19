import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/asteroid_view_model.dart';

class DetailsPage extends StatelessWidget {
  final String asteroidId;

  const DetailsPage({super.key, required this.asteroidId});

  @override
  Widget build(BuildContext context) {
    final asteroidViewModel = Provider.of<AsteroidViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroid Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Asteroid Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
              future:
                  asteroidViewModel.apiService.fetchAsteroidDetails(asteroidId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final asteroidDetails = snapshot.data as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${asteroidDetails['name']}'),
                      Text(
                          'Dangerous: ${asteroidDetails['is_potentially_hazardous_asteroid']}'),
                      // Add more details as needed
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Closest Approach Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
              future: asteroidViewModel.apiService
                  .fetchClosestApproachInfo(asteroidId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final closestApproachInfo =
                      snapshot.data as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${closestApproachInfo['date']}'),
                      Text(
                          'Relative Velocity: ${closestApproachInfo['relative_velocity']}'),
                      // Add more information as needed
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
