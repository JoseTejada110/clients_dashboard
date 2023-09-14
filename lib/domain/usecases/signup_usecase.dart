import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/usecases/catch_request_exceptions.dart';

class SignupUsecase {
  SignupUsecase(this.apiRepository);
  final ApiRepositoryInteface apiRepository;

  Future<Either<FailureEntity, String?>> signupUser(
    String email,
    String password,
    Map<String, dynamic> userData,
    File identificationImage,
    File faceImage,
    File addressProofImage,
  ) async {
    return await catchRequestExceptions<String>(() async {
      return await apiRepository.signupUser(
        email,
        password,
        userData,
        identificationImage,
        faceImage,
        addressProofImage,
      );
    });
  }
}
