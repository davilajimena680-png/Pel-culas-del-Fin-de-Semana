/// Entidad pura del dominio.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    this.posterUrl,
    this.releaseYear,
  });

  final int id;
  final String title;
  final String overview;
  final double voteAverage;
  final String? posterUrl;
  final String? releaseYear;
}
