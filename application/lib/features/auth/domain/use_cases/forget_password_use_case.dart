import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';

class ForgetPasswordUsecase {
  final AuthRepo authRepo;

  ForgetPasswordUsecase(this.authRepo);

  Future<Either<Failure, void>> execute({required String email}) async {
   var res = await authRepo.forgetPassword(email: email);
   return(res);
  }
}
