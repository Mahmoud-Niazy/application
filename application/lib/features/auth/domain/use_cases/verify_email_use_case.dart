
import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/auth_response_model.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';

class VerifyEmailUsecase {
  final AuthRepo authRepo;

  VerifyEmailUsecase(this.authRepo);

  Future<Either<Failure,AuthResponseModel>> execute({
    required String code,
    required String email,
  }) async {
   var res = await authRepo.verifyEmail(
      code: code,
      email: email,
    );
    return  res;
  }
}
