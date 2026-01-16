import 'package:get_it/get_it.dart';
import 'package:test/features/auth/data/repos/user_repo_imp.dart';
import 'package:test/features/auth/domain/repos/auth_repo.dart';
import 'package:test/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:test/features/auth/domain/use_cases/reset_password_use_case.dart';
import 'package:test/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:test/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:test/features/auth/domain/use_cases/verify_email_use_case.dart';
import 'package:test/features/auth/presentation/manager/auth_cubit.dart';
import 'package:test/features/home/data/repos/home_repo_imp.dart';
import 'package:test/features/home/domain/repos/home_repo.dart';
import 'package:test/features/home/domain/usecases/get_all_users_use_case.dart';
import 'package:test/features/home/presentation/manager/home_cubit.dart';
import 'package:test/features/profile/data/repos/profile_repo_imp.dart';
import 'package:test/features/profile/domain/repos/profile_repo.dart';
import 'package:test/features/profile/domain/use%20cases/get_profile_use_case.dart';
import 'package:test/features/profile/presentation/manager/profile_cubit.dart';

import '../api/api_services.dart';

final serviceLocator = GetIt.instance;

class ServiceLocator {
  static void init() {
    ///API SERVICE
    serviceLocator.registerLazySingleton<ApiServices>(() => ApiServices());

    /// REPOS
    serviceLocator.registerLazySingleton<AuthRepo>(
      () => AuthRepoImp(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<ProfileRepo>(
      () => ProfileRepoImp(serviceLocator()),
    );
        serviceLocator.registerLazySingleton<HomeRepo>(
      () => HomeRepoImp(serviceLocator()),
    );

    /// USE CASES
    serviceLocator.registerLazySingleton<SignInUsecase>(
      () => SignInUsecase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(serviceLocator()),
    );

    serviceLocator.registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<VerifyEmailUsecase>(
      () => VerifyEmailUsecase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<ForgetPasswordUsecase>(
      () => ForgetPasswordUsecase(serviceLocator()),
    );
    serviceLocator.registerLazySingleton<GetProfileUsecase>(
      () => GetProfileUsecase(serviceLocator()),
    );
       serviceLocator.registerLazySingleton<GetAllUsersUsecase>(
      () => GetAllUsersUsecase(serviceLocator()),
    );

    /// CUBIT
    serviceLocator.registerFactory<AuthCubit>(
      () => AuthCubit(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    );
    serviceLocator.registerFactory<ProfileCubit>(
      () => ProfileCubit(serviceLocator()),
    );
        serviceLocator.registerFactory<HomeCubit>(
      () => HomeCubit(serviceLocator()),
    );
  }
}
