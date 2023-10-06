import 'package:dartz/dartz.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/data/models/user_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/usecases/catch_request_exceptions.dart';

class LoginUsecase {
  LoginUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, UserModel>> signIn(
    String email,
    String password,
  ) async {
    return await catchRequestExceptions(() async {
      return await apiRepository.signinUser(email, password);
    });
  }
}
