/// Estado de ánimo del usuario. Cada uno se traduce a un género de TMDB.
enum Mood {
  trending('Tendencias', '🔥', null),
  happy('Feliz', '😄', 35),
  sad('Triste', '😢', 18),
  excited('Con adrenalina', '🤩', 28),
  scared('Con ganas de miedo', '😱', 27),
  romantic('Romántico', '😍', 10749),
  curious('Curioso', '🤔', 878);

  const Mood(this.label, this.emoji, this.genreId);

  final String label;
  final String emoji;

  /// Id de género en TMDB. `null` = lista de tendencias de la semana.
  final int? genreId;
}
