import 'package:dartz/dartz.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/catch_request_exceptions.dart';

class GeneralUsecase {
  GeneralUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, List<T>>> readData<T>(
      FirebaseParamsRequest params) async {
    return await catchRequestExceptions(() async {
      return await apiRepository.readData<T>(params);
    });
  }

  Future<Either<FailureEntity, String>> writeData(
      FirebaseParamsRequest params) async {
    return await catchRequestExceptions<String>(() async {
      return await apiRepository.writeData(params);
    });
  }

  Future<Either<FailureEntity, T>> executeFirebaseQueries<T>(
      Future<dynamic> Function() queries) async {
    return await catchRequestExceptions<T>(() async {
      return await apiRepository.executeFirebaseQueries<T>(queries);
    });
  }
}
