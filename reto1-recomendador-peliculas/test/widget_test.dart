import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/entities/mood.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/entities/movie.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/repositories/movie_repository.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/usecases/get_movies_by_mood.dart';
import 'package:reto1_recomendador_peliculas/features/movies/presentation/pages/movies_page.dart';
import 'package:reto1_recomendador_peliculas/features/movies/presentation/providers/movies_provider.dart';

class _FakeRepository implements MovieRepository {
  @override
  Future<List<Movie>> getMovies(Mood mood) async => const [
        Movie(id: 1, title: 'Película Uno', overview: 'Sinopsis', voteAverage: 7.5),
      ];
}

void main() {
  testWidgets('muestra los ánimos y la película destacada', (tester) async {
    final provider = MoviesProvider(GetMoviesByMood(_FakeRepository()));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: MoviesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tu película de hoy'), findsOneWidget);
    expect(find.text('Película Uno'), findsOneWidget);
    expect(find.textContaining('Feliz'), findsOneWidget);
  });
}
