class ServerException implements Exception {
  ServerException(String e);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException(this.message);
}

class DataNotFoundException implements Exception {}
