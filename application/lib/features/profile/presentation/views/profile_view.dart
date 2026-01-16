import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/core/service%20locator/service_locator.dart';
import 'package:test/core/utils/app_colors.dart';
import 'package:test/core/utils/app_styles.dart';
import 'package:test/core/widgets/custom_button.dart';
import 'package:test/core/widgets/custom_loading_widget.dart';
import 'package:test/features/profile/presentation/manager/profile_cubit.dart';
import 'package:test/features/profile/presentation/manager/profile_states.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ProfileCubit>()..getProfile(),
      child: BlocBuilder<ProfileCubit, ProfileStates>(
        builder: (context, state) {
          var cubit = ProfileCubit.get(context);
          if (state is GetProfileLoadingState) {
            return CustomLoadingWidget();
          }
          if (state is ProfileErrorState) {
            return Center(child: Text(state.error));
          }
          return SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  
                      CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        radius: 40,
                      ),
                      SizedBox(height: 30),
                  
                      Text(
                        "Name : ${cubit.profileData?.name ?? ''}",
                        style: AppStyles.style20Bold,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Type : ${cubit.profileData?.role ?? ''}",
                        style: AppStyles.style20Bold,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Email : ${cubit.profileData?.email ?? ''}",
                        style: AppStyles.style20Bold,
                      ),
                      SizedBox(height: 30),
                      CustomButton(
                        backgroundColor: Colors.red,
                        title: "Logout",
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutesNames.login,
                            (_) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
