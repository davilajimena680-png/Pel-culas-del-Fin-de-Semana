import 'dart:async';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_datasource.dart';

/// Traduce las excepciones de datos a `Failure` del dominio.
class MovieRepositoryImpl implements MovieRepository {
  const MovieRepositoryImpl(this._dataSource);

  final MovieRemoteDataSource _dataSource;

  @override
  Future<List<Movie>> getMovies(Mood mood) async {
    try {
      return await _dataSource.fetchMovies(mood);
    } on ConfigException catch (e) {
      throw ConfigFailure(e.message);
    } on ServerException catch (e) {
      if (e.statusCode == 401) {
        throw const ConfigFailure('Tu API key de TMDB no es válida.');
      }
      throw const ServerFailure();
    } on http.ClientException {
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    }
  }
}
