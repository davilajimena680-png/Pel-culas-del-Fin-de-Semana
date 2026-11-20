import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reto1_recomendador_peliculas/core/error/exceptions.dart';
import 'package:reto1_recomendador_peliculas/core/error/failures.dart';
import 'package:reto1_recomendador_peliculas/features/movies/data/datasources/movie_remote_datasource.dart';
import 'package:reto1_recomendador_peliculas/features/movies/data/models/movie_model.dart';
import 'package:reto1_recomendador_peliculas/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:reto1_recomendador_peliculas/features/movies/domain/entities/mood.dart';

http.Response _json(Object body, [int status = 200]) => http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

void main() {
  group('MovieModel', () {
    test('parsea un JSON completo', () {
      final movie = MovieModel.fromJson({
        'id': 1,
        'title': 'Matrix',
        'overview': 'Neo despierta.',
        'vote_average': 8,
        'poster_path': '/abc.jpg',
        'release_date': '1999-03-31',
      });

      expect(movie.id, 1);
      expect(movie.title, 'Matrix');
      expect(movie.voteAverage, 8.0);
      expect(movie.posterUrl, 'https://image.tmdb.org/t/p/w500/abc.jpg');
      expect(movie.releaseYear, '1999');
    });

    test('tolera campos nulos', () {
      final movie = MovieModel.fromJson({'id': 2});

      expect(movie.title, 'Sin título');
      expect(movie.posterUrl, isNull);
      expect(movie.releaseYear, isNull);
      expect(movie.voteAverage, 0);
    });
  });

  group('MovieRemoteDataSource', () {
    test('tendencias usa /trending y sin género', () {
      final ds = MovieRemoteDataSource(MockClient((_) async => _json({})),
          apiKey: 'k');
      final uri = ds.buildUri(Mood.trending);

      expect(uri.path, '/3/trending/movie/week');
      expect(uri.queryParameters.containsKey('with_genres'), isFalse);
      expect(uri.queryParameters['api_key'], 'k');
    });

    test('un ánimo usa /discover con su género', () {
      final ds = MovieRemoteDataSource(MockClient((_) async => _json({})),
          apiKey: 'k');
      final uri = ds.buildUri(Mood.happy);

      expect(uri.path, '/3/discover/movie');
      expect(uri.queryParameters['with_genres'], '35');
    });

    test('sin API key lanza ConfigException', () {
      final ds = MovieRemoteDataSource(MockClient((_) async => _json({})),
          apiKey: '');

      expect(ds.fetchMovies(Mood.happy), throwsA(isA<ConfigException>()));
    });

    test('status distinto de 200 lanza ServerException', () {
      final ds = MovieRemoteDataSource(
          MockClient((_) async => _json({}, 500)),
          apiKey: 'k');

      expect(ds.fetchMovies(Mood.happy), throwsA(isA<ServerException>()));
    });

    test('parsea la lista de resultados', () async {
      final ds = MovieRemoteDataSource(
        MockClient((_) async => _json({
              'results': [
                {'id': 1, 'title': 'Acción ñ'},
                {'id': 2, 'title': 'B'},
              ],
            })),
        apiKey: 'k',
      );

      final movies = await ds.fetchMovies(Mood.excited);

      expect(movies.length, 2);
      expect(movies.first.title, 'Acción ñ');
    });
  });

  group('MovieRepositoryImpl', () {
    test('401 se traduce a ConfigFailure', () {
      final repo = MovieRepositoryImpl(MovieRemoteDataSource(
          MockClient((_) async => _json({}, 401)),
          apiKey: 'k'));

      expect(repo.getMovies(Mood.sad), throwsA(isA<ConfigFailure>()));
    });

    test('error de red se traduce a NetworkFailure', () {
      final repo = MovieRepositoryImpl(MovieRemoteDataSource(
          MockClient((_) async => throw http.ClientException('sin red')),
          apiKey: 'k'));

      expect(repo.getMovies(Mood.sad), throwsA(isA<NetworkFailure>()));
    });
  });
}
