import 'package:dartz/dartz.dart';
import 'package:test/core/utils/failure.dart';
import 'package:test/features/auth/data/models/user_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<UserModel>>> getAllUsers();
}