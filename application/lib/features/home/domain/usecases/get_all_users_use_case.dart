import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/home/domain/repos/home_repo.dart';

class GetAllUsersUsecase {
  final HomeRepo homeRepo;

  GetAllUsersUsecase(this.homeRepo);

  Future<Either<Failure, List<UserModel>>> execute() async {
    var res = await homeRepo.getAllUsers();
    return (res);
  }
}
