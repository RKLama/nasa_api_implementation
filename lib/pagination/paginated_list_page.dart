import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dashboard/dashboard_page.dart';
import '../services/api_service.dart';
import '../view_model/asteroid_view_model.dart';

class PaginatedListPage extends StatelessWidget {
  const PaginatedListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApiService(),
      child: ChangeNotifierProvider(
        create: (context) =>
            AsteroidViewModel(apiService: context.read<ApiService>()),
        child: const PaginatedListPageContent(),
      ),
    );
  }
}

class PaginatedListPageContent extends StatelessWidget {
  const PaginatedListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final asteroidViewModel = Provider.of<AsteroidViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroid List'),
      ),
      body: FutureBuilder(
        future: asteroidViewModel.asteroids.isEmpty
            ? asteroidViewModel.fetchAsteroids()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: asteroidViewModel.asteroids.length,
              itemBuilder: (context, index) {
                final asteroid = asteroidViewModel.asteroids[index];
                return ListTile(
                  title: Text(asteroid['name']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsPage(asteroidId: asteroid['id']),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
