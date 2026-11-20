/// Errores "crudos" que lanza la capa de datos.
class ServerException implements Exception {
  const ServerException([this.statusCode]);

  final int? statusCode;
}

class ConfigException implements Exception {
  const ConfigException(this.message);

  final String message;
}
