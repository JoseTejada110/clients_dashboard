import 'package:dartz/dartz.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/usecases/catch_request_exceptions.dart';

class LoginUsecase {
  LoginUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, dynamic>> signIn(
      Map<String, dynamic> body) async {
    return await catchRequestExceptions(() async {
      //TODO: SIGN THE USER IN
      return 1;
      // final params = ApiParamsRequest(
      //   url: '/signIn',
      //   body: body,
      // );
      // final result = await apiRepository.executePostRequest(params);
      // final user = User.fromJson(result['user']);
      // return LoginResponse(
      //   user: user,
      //   token: result['access_token'],
      //   expiresAt: DateTime.parse(result['expires_at']),
      // );
    });
  }
}
