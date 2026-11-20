import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'core/config/env.dart';
import 'features/movies/data/datasources/movie_remote_datasource.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/domain/usecases/get_movies_by_mood.dart';
import 'features/movies/presentation/pages/movies_page.dart';
import 'features/movies/presentation/providers/movies_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Sin .env la app mostrará un aviso de que falta la API key.
  }

  // Composición de dependencias: datasource -> repositorio -> caso de uso.
  final dataSource = MovieRemoteDataSource(
    http.Client(),
    apiKey: Env.tmdbApiKey,
  );
  final repository = MovieRepositoryImpl(dataSource);
  final getMoviesByMood = GetMoviesByMood(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => MoviesProvider(getMoviesByMood),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recomendador de Películas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MoviesPage(),
    );
  }
}
