import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/auth_response_model.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/models/user_registration_request_model.dart';

abstract class AuthRepo {
  Future<Either<Failure,AuthResponseModel>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure,UserModel>> signUp(UserRegistrationRequestModel registerData);

    Future<Either<Failure,AuthResponseModel>> verifyEmail({
      required String email,
      required String code
    });

       Future<Either<Failure,void>> forgetPassword({
      required String email,
    });
  

  Future<Either<Failure, void>> resetPassword({
    required String code,
    required String newPassword,
    required String email,
});



}
