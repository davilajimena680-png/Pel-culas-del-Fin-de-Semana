import '../entities/mood.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  /// Lanza un `Failure` si algo sale mal.
  Future<List<Movie>> getMovies(Mood mood);
}
