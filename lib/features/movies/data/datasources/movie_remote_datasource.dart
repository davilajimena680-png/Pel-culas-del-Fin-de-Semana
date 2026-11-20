import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/mood.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  MovieRemoteDataSource(this._client, {required this.apiKey});

  final http.Client _client;
  final String apiKey;

  /// Tendencias de la semana, o descubrir por género según el ánimo.
  Uri buildUri(Mood mood) {
    final genre = mood.genreId;
    return Uri.https(
      ApiConstants.host,
      genre == null ? '/3/trending/movie/week' : '/3/discover/movie',
      {
        'api_key': apiKey,
        'language': ApiConstants.language,
        if (genre != null) ...{
          'with_genres': '$genre',
          'sort_by': 'popularity.desc',
          'vote_count.gte': '200',
          'include_adult': 'false',
        },
      },
    );
  }

  Future<List<MovieModel>> fetchMovies(Mood mood) async {
    if (apiKey.isEmpty) {
      throw const ConfigException(
        'Falta tu API key de TMDB. Pégala en el archivo .env (TMDB_API_KEY).',
      );
    }

    final response =
        await _client.get(buildUri(mood)).timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }

    final body = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
    final results = (body['results'] as List<dynamic>?) ?? const [];

    return results
        .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
