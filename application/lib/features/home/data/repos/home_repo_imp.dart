import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:test/core/api/api_services.dart';
import 'package:test/core/cache/cache_helper.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/home/data/end%20points/home_end_points.dart';
import 'package:test/features/home/domain/repos/home_repo.dart';

class HomeRepoImp extends HomeRepo {
  final ApiServices apiServices;
  HomeRepoImp(this.apiServices);
  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      var res = await apiServices.getData(
        path: HomeEndPoints.getAllUsers,
        token: CacheHelper.token,
      );
      List<UserModel> users = [];
      for (var user in res.data['data']['items']) {
        users.add(UserModel.fromJson(user));
      }
      return right(users);
    } catch (error) {
      if (error is DioException) {
        return left(ServerFailure.fromDioException(error));
      } else {
        return left(ServerFailure(error.toString()));
      }
    }
  }
}
