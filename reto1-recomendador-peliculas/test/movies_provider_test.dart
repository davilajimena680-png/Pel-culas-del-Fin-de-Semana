import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:reto1_recomendador_peliculas/core/error/failures.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/entities/mood.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/entities/movie.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/repositories/movie_repository.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/usecases/get_movies_by_mood.dart';
import 'package:reto1_recomendador_peliculas/features/movies/presentation/providers/movies_provider.dart';

class FakeRepository implements MovieRepository {
  FakeRepository({this.movies = const [], this.failure});

  final List<Movie> movies;
  final Failure? failure;
  Mood? lastMood;

  @override
  Future<List<Movie>> getMovies(Mood mood) async {
    lastMood = mood;
    if (failure != null) throw failure!;
    return movies;
  }
}

const _movies = [
  Movie(id: 1, title: 'A', overview: '', voteAverage: 7),
  Movie(id: 2, title: 'B', overview: '', voteAverage: 8),
  Movie(id: 3, title: 'C', overview: '', voteAverage: 9),
];

void main() {
  test('carga tendencias al iniciar y destaca una película', () async {
    final repo = FakeRepository(movies: _movies);
    final provider = MoviesProvider(GetMoviesByMood(repo), random: Random(1));

    expect(provider.status, MoviesStatus.loading);
    await Future<void>.delayed(Duration.zero);

    expect(provider.status, MoviesStatus.success);
    expect(repo.lastMood, Mood.trending);
    expect(_movies.map((m) => m.id), contains(provider.featured!.id));
    expect(provider.others.length, 2);
  });

  test('selectMood pide las películas del ánimo elegido', () async {
    final repo = FakeRepository(movies: _movies);
    final provider = MoviesProvider(GetMoviesByMood(repo), random: Random(1));
    await Future<void>.delayed(Duration.zero);

    await provider.selectMood(Mood.scared);

    expect(repo.lastMood, Mood.scared);
    expect(provider.mood, Mood.scared);
  });

  test('un Failure deja el estado en error con su mensaje', () async {
    final repo = FakeRepository(failure: const NetworkFailure());
    final provider = MoviesProvider(GetMoviesByMood(repo));
    await Future<void>.delayed(Duration.zero);

    expect(provider.status, MoviesStatus.error);
    expect(provider.errorMessage, contains('Sin conexión'));
  });

  test('surpriseMe mantiene una película de la lista', () async {
    final repo = FakeRepository(movies: _movies);
    final provider = MoviesProvider(GetMoviesByMood(repo), random: Random(7));
    await Future<void>.delayed(Duration.zero);

    provider.surpriseMe();

    expect(_movies.map((m) => m.id), contains(provider.featured!.id));
  });
}
