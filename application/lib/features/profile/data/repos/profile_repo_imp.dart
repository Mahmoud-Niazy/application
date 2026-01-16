import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/core/api/api_services.dart';
import 'package:test/core/cache/cache_helper.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/profile/data/end%20points/profile_end_points.dart';
import 'package:test/features/profile/domain/repos/profile_repo.dart';

class ProfileRepoImp extends ProfileRepo{
  final ApiServices apiServices;
  ProfileRepoImp(this.apiServices);
  @override
  Future<Either<Failure, UserModel>> getProfileData() async{
    try {
      var res = await apiServices.getData(
        path: ProfileEndPoints.profile,
        token: CacheHelper.token,
      );
      var user = UserModel.fromJson(res.data['data']);
      return right(user);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }

}