import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Acceso seguro a las variables del archivo .env
class Env {
  const Env._();

  static String get tmdbApiKey {
    try {
      return (dotenv.maybeGet('TMDB_API_KEY') ?? '').trim();
    } catch (_) {
      // dotenv no se pudo cargar: se trata como "sin llave".
      return '';
    }
  }
}
