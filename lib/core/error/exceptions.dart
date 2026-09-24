abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Unexpected server error.']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Local cache error.']);
}
