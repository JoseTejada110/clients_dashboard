// NOTA: Para el manejo de errores se utilizó el patrón de diseño 'Visitor'.

/// Representa una entidad de fallo genérica.
abstract class FailureEntity {
  const FailureEntity();

  /// Método para aceptar una entidad de FailureVisitor y manejar los distintos fallos que pueden ocurrir en la app.
  void accept(FailureVisitor visitor);
}

/// Representa un fallo del servidor.
class ServerFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const ServerFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo del servidor.
    visitor.visitServerFailure(this);
  }
}

/// Representa un fallo en la conversión de un objeto dart.
class DataParsingFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const DataParsingFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo en la conversión.
    visitor.visitDataParsingFailure(this);
  }
}

/// Representa un fallo de conexión.
class NoConnectionFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const NoConnectionFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo de conexión.
    visitor.visitNoConnectionFailure(this);
  }
}

/// Representa un fallo de tiempo de espera.
class TimeoutFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const TimeoutFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo de tiempo de espera.
    visitor.visitTimeoutFailure(this);
  }
}

/// Representa un fallo de que el usuario no tiene permiso para ejecutar la acción.
class UnauthorizedFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const UnauthorizedFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo de autorización.
    visitor.visitUnauthorizedFailure(this);
  }
}

/// Representa un fallo inesperado.
class UnhandledFailure extends FailureEntity {
  /// Constructor que recibe el mensaje de error del servidor.
  const UnhandledFailure({this.message});
  final Map<String, dynamic>? message;

  @override
  void accept(FailureVisitor visitor) {
    /// Invoca el método correspondiente en el visitante para el fallo inesperado.
    visitor.visitUnhandledFailure(this);
  }
}

abstract class FailureVisitor {
  const FailureVisitor();
  void visitServerFailure(ServerFailure failure);
  void visitDataParsingFailure(DataParsingFailure failure);
  void visitNoConnectionFailure(NoConnectionFailure failure);
  void visitTimeoutFailure(TimeoutFailure failure);
  void visitUnauthorizedFailure(UnauthorizedFailure failure);
  void visitUnhandledFailure(UnhandledFailure failure);
}

class FailureHandler implements FailureVisitor {
  late ErrorResponse errorResponse;
  @override
  void visitDataParsingFailure(DataParsingFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'Error al procesar los datos',
      message:
          'Al parecer la aplicación no está actualizada, actualice la app e intente de nuevo.',
    );
  }

  @override
  void visitNoConnectionFailure(NoConnectionFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'No hay conexión a internet',
      message: failure.message?['mensaje_error'] ??
          'Al parecer su dispositivo no está conectado a internet, verifique su conexión a internet e intente de nuevo.',
    );
  }

  @override
  void visitServerFailure(ServerFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'Algo ha salido mal',
      message: failure.message?['mensaje_error'] ??
          'Ha ocurrido una excepción inesperada, intente de nuevo más tarde.',
    );
  }

  @override
  void visitTimeoutFailure(TimeoutFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'Tiempo de espera agotado',
      message: failure.message?['mensaje_error'] ??
          'No ha sido posible conectarse con el servidor, verifique su conexión a internet e intente de nuevo.',
    );
  }

  @override
  void visitUnauthorizedFailure(UnauthorizedFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'No autorizado',
      message: failure.message?['mensaje_error'] ??
          'No tienes permiso para ejecutar esta acción',
    );
  }

  @override
  void visitUnhandledFailure(UnhandledFailure failure) {
    errorResponse = ErrorResponse(
      title: failure.message?['titulo_error'] ?? 'Excepción Inesperada',
      message: failure.message?['mensaje_error'] ??
          'Ha ocurrido una excepción inesperada, intente de nuevo más tarde.',
    );
  }
}

/// Función para manejar y obtener el mensaje de un error recibiendo un objeto de tipo FailureEntity.
ErrorResponse getMessageFromFailure(FailureEntity failure) {
  final visitor = FailureHandler();
  failure.accept(visitor);
  return visitor.errorResponse;
}

/// Clase que contendrá los mensajes de error
class ErrorResponse {
  const ErrorResponse({required this.title, required this.message});
  final String title;
  final String message;

  @override
  String toString() => '$title|$message';
}
