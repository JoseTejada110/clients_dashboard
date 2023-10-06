import 'package:dartz/dartz.dart';
import 'package:bisonte_app/core/error_handling/exceptions.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';

/// Método para reutilizar el mismo bloque try-catch en todas las peticiones
Future<Either<FailureEntity, T>> catchRequestExceptions<T>(
  Future<dynamic> Function() request,
) async {
  try {
    return Right(await request());
  } catch (e) {
    if (e is ServerException) {
      return Left(ServerFailure(message: e.message));
    } else if (e is DataParsingException) {
      return Left(DataParsingFailure(message: e.message));
    } else if (e is CustomTimeoutException) {
      return Left(TimeoutFailure(message: e.message));
    } else if (e is NoConnectionException) {
      return Left(NoConnectionFailure(message: e.message));
    } else if (e is UnauthorizedException) {
      return Left(UnauthorizedFailure(message: e.message));
    } else if (e is UnhandledException) {
      return Left(UnhandledFailure(message: e.message));
    } else {
      return const Left(UnhandledFailure());
    }
  }
}
