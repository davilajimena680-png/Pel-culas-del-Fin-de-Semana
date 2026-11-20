import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/mood.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_by_mood.dart';

enum MoviesStatus { loading, success, error }

class MoviesProvider extends ChangeNotifier {
  MoviesProvider(this._getMovies, {Random? random})
      : _random = random ?? Random() {
    selectMood(Mood.trending);
  }

  final GetMoviesByMood _getMovies;
  final Random _random;

  MoviesStatus _status = MoviesStatus.loading;
  Mood _mood = Mood.trending;
  List<Movie> _movies = const [];
  Movie? _featured;
  String? _errorMessage;
  int _requestId = 0;

  MoviesStatus get status => _status;
  Mood get mood => _mood;
  List<Movie> get movies => _movies;
  Movie? get featured => _featured;
  String? get errorMessage => _errorMessage;

  /// Resto de películas (sin la destacada).
  List<Movie> get others =>
      _movies.where((m) => m.id != _featured?.id).toList();

  Future<void> selectMood(Mood mood) async {
    final requestId = ++_requestId;
    _mood = mood;
    _status = MoviesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _getMovies(mood);
      if (requestId != _requestId) return; // llegó una petición más nueva
      _movies = result;
      _featured = _pickRandom();
      _status = MoviesStatus.success;
    } on Failure catch (failure) {
      if (requestId != _requestId) return;
      _errorMessage = failure.message;
      _status = MoviesStatus.error;
    } catch (_) {
      if (requestId != _requestId) return;
      _errorMessage = 'Ocurrió un error inesperado.';
      _status = MoviesStatus.error;
    }
    notifyListeners();
  }

  /// Elige otra película al azar de la lista cargada.
  void surpriseMe() {
    if (_movies.isEmpty) return;
    _featured = _pickRandom();
    notifyListeners();
  }

  Movie? _pickRandom() =>
      _movies.isEmpty ? null : _movies[_random.nextInt(_movies.length)];
}
