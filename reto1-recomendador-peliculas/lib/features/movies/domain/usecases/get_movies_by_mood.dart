import '../entities/mood.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMoviesByMood {
  const GetMoviesByMood(this._repository);

  final MovieRepository _repository;

  Future<List<Movie>> call(Mood mood) => _repository.getMovies(mood);
}
