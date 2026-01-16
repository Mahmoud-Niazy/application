import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo authRepo;

  ResetPasswordUseCase(this.authRepo);

  Future<Either<Failure, void>> execute({
    required String code,
    required String newPassword,
    required String email,
  }) async {
    var res = await authRepo.resetPassword(
      code: code,
      newPassword: newPassword,
      email: email,
    );
    return res;
  }
}
