import 'package:test/features/home/data/models/user_type_enum.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthErrorState extends AuthStates {
  final String error;

  AuthErrorState(this.error);
}


class SignInLoadingState extends AuthStates {}
class SignInSuccessfullyState extends AuthStates {

}


class SignUpLoadingState extends AuthStates {}
class SignUpSuccessfullyState extends AuthStates {}

class VerifyEmailLoadingState extends AuthStates {}
class VerifyEmailSuccessfullyState extends AuthStates {

}

class ForgetPasswordLoadingState extends AuthStates{}
class ForgetPasswordSuccessfullyState extends AuthStates{}


class ResetPasswordLoadingState extends AuthStates{}
class ResetPasswordSuccessfullyState extends AuthStates{}







