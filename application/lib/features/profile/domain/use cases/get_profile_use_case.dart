import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/profile/domain/repos/profile_repo.dart';

class GetProfileUsecase {
  final ProfileRepo profileRepo;

  GetProfileUsecase(this.profileRepo);

  Future<Either<Failure, UserModel>> execute() async {
    var res = await profileRepo.getProfileData();
    return (res);
  }
}
