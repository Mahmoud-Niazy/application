import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/auth_response_model.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';

class SignInUsecase {
  final AuthRepo authRepo;

  SignInUsecase(this.authRepo);

  Future<Either<Failure, AuthResponseModel>> execute({
    required String email,
    required String password,
  }) async {
    var res = await authRepo.signIn(email: email, password: password);
    return res;
  }
}
