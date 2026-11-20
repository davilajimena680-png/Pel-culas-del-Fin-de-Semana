import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.voteAverage,
    super.posterUrl,
    super.releaseYear,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final poster = json['poster_path'] as String?;
    final date = json['release_date'] as String?;

    return MovieModel(
      id: json['id'] as int,
      title: (json['title'] as String?) ?? 'Sin título',
      overview: (json['overview'] as String?) ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      posterUrl: poster == null ? null : '${ApiConstants.imageBaseUrl}$poster',
      releaseYear: (date != null && date.length >= 4) ? date.substring(0, 4) : null,
    );
  }
}
