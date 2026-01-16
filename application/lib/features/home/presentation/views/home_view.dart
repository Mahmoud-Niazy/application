import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/cache/cache_helper.dart';
import 'package:test/core/service%20locator/service_locator.dart';
import 'package:test/features/home/data/models/user_type_enum.dart';
import 'package:test/features/home/presentation/manager/home_cubit.dart';
import 'package:test/features/home/presentation/views/admin/home_admin_view.dart';
import 'package:test/features/home/presentation/views/manager/home_manager_view.dart';
import 'package:test/features/home/presentation/views/user/home_user_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    UserType userType = getUserTypeByKey(CacheHelper.userType ?? '');
    return BlocProvider(
      create: (context) => serviceLocator<HomeCubit>()..getAllUsers(),
      child: Scaffold(
        body: userType == UserType.manager
            ? HomeManagerView()
            : userType == UserType.adimn
            ? HomeAdminView()
            : HomeUserView(),
      ),
    );
  }
}
