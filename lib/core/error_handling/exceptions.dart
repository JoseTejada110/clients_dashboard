class ServerException implements Exception {
  ServerException({this.message});
  final Map<String, dynamic>? message;
}

class DataParsingException implements Exception {
  DataParsingException({this.message});
  final Map<String, dynamic>? message;
}

class NoConnectionException implements Exception {
  NoConnectionException({this.message});
  final Map<String, dynamic>? message;
}

class CustomTimeoutException implements Exception {
  CustomTimeoutException({this.message});
  final Map<String, dynamic>? message;
}

class UnauthorizedException implements Exception {
  UnauthorizedException({this.message});
  final Map<String, dynamic>? message;
}

class UnhandledException implements Exception {
  UnhandledException({this.message});
  final Map<String, dynamic>? message;
}
