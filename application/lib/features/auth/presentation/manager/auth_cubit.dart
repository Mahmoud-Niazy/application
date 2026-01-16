import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/cache/cache_helper.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/core/utils/keys.dart';
import 'package:test/features/auth/data/models/user_registration_request_model.dart';
import 'package:test/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:test/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:test/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:test/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:test/features/auth/domain/use_cases/verify_email_use_case.dart';

import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final SignInUsecase signInUseCase;
  final SignUpUsecase signUpUseCase;
  final VerifyEmailUsecase verifyEmailUseCase;
  final ForgetPasswordUsecase forgetPasswordUsecase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit(
    this.signInUseCase,
    this.signUpUseCase,
    this.resetPasswordUseCase,
    this.verifyEmailUseCase,
    this.forgetPasswordUsecase,
  ) : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  Future<void> signIn({required String email, required String password}) async {
    emit(SignInLoadingState());
    var res = await signInUseCase.execute(email: email, password: password);
    res.fold(
      (failure) {
        emit(AuthErrorState(failure.error));
      },
      (user) async {
        await CacheHelper.saveData(key: AppKeys.token, value: user.token);
        await CacheHelper.saveData(key: AppKeys.userType, value: user.user.role);

        emit(SignInSuccessfullyState());
      },
    );
  }

  Future<void> signUp(UserRegistrationRequestModel registerData) async {
    emit(SignUpLoadingState());
    var res = await signUpUseCase.execute(registerData);
    res.fold(
      (error) {
        emit(AuthErrorState(error.error));
      },
      (userData) {
        emit(SignUpSuccessfullyState());
      },
    );
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    emit(VerifyEmailLoadingState());
    var res = await verifyEmailUseCase.execute(code: code, email: email);
    res.fold(
      (error) {
        emit(AuthErrorState(error.error));
      },
      (user) async {
        await CacheHelper.saveData(key: AppKeys.token, value: user.token);
        await CacheHelper.saveData(key: AppKeys.userType, value: user.user.role);

        emit(VerifyEmailSuccessfullyState());
      },
    );
  }

  Future<void> forgetPassword({required String email}) async {
    emit(ForgetPasswordLoadingState());
    var res = await forgetPasswordUsecase.execute(email: email);
    res.fold(
      (error) {
        emit(AuthErrorState(error.error));
      },
      (success) async {
        emit(ForgetPasswordSuccessfullyState());
      },
    );
  }

  Future<void> resetPassword({
    required String code,
    required String newPassword,
    required String email,
  }) async {
    emit(ResetPasswordLoadingState());
    try {
      await resetPasswordUseCase.execute(
        code: code,
        newPassword: newPassword,
        email: email,
      );
      emit(ResetPasswordSuccessfullyState());
    } catch (error) {
      if (error is DioException) {
        emit(AuthErrorState(ServerFailure.fromDioException(error).error));
      } else {
        emit(AuthErrorState(error.toString()));
      }
    }
  }
}
