import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/core/api/api_services.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/end%20points/auth_end_points.dart';
import 'package:test/features/auth/data/models/auth_response_model.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/models/user_registration_request_model.dart';

import '../../domain/repos/auth_repo.dart';

class AuthRepoImp extends AuthRepo {
  final ApiServices apiServices;

  AuthRepoImp(this.apiServices);

  @override
  Future<Either<Failure, AuthResponseModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var res = await apiServices.postData(
        path: AuthEndPoints.login,
        data: {"email": email, "password": password},
      );
      var user = AuthResponseModel.fromJson(res.data['data']);
      return right(user);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp(
    UserRegistrationRequestModel registerData,
  ) async {
    try {
      var res = await apiServices.postData(
        path: AuthEndPoints.register,
        data: registerData.toJson(),
      );
      var user = res.data['data'];
      return right(UserModel.fromJson(user));
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthResponseModel>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      var res = await apiServices.postData(
        path: AuthEndPoints.emailVerify,
        data: {"email": email, "code": code},
      );
      var user = AuthResponseModel.fromJson(res.data['data']);
      return right(user);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> forgetPassword({required String email}) async {
    try {
      await apiServices.postData(
        path: AuthEndPoints.forgetPassword,
        data: {"email": email},
      );
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String code,
    required String newPassword,
    required String email,
  }) async {
    try {
      await apiServices.postData(
        path: AuthEndPoints.resetPassword,
        data: {
          "code": code,
          "email": email,
          "password": newPassword,
          "password_confirmation": newPassword,
        },
      );
      return right(null);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }
}
