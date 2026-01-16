import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/models/user_registration_request_model.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo authRepo;

  SignUpUsecase(this.authRepo);

  Future<Either<Failure,UserModel>> execute(UserRegistrationRequestModel registerData) async {
    var res = await authRepo.signUp(
     registerData
    );
    return res;
  }
}
