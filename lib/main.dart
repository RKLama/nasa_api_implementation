import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pagination/paginated_list_page.dart';
import 'services/api_service.dart';
import 'view_model/asteroid_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApiService()),
        ChangeNotifierProvider(
            create: (context) =>
                AsteroidViewModel(apiService: context.read<ApiService>())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA INFO',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const PaginatedListPage(),
    );
  }
}
