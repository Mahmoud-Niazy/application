import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/router/app_routes_names.dart';
import 'package:test/core/widgets/custom_loading_widget.dart';
import 'package:test/core/widgets/custom_text_button.dart';
import 'package:test/features/home/presentation/manager/home_cubit.dart';
import 'package:test/features/home/presentation/manager/home_states.dart';

class HomeManagerView extends StatelessWidget {
  const HomeManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        if (state is GetAllUsersLoadingState) {
          return CustomLoadingWidget();
        }
        if (state is HomeErrorState) {
          return Center(child: Text(state.error));
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome,"),
              SizedBox(height: 30),
              Text('Users number : ${cubit.users.length} '),
              SizedBox(height: 30),

              CustomTextButton(
                title: "Users Management",
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutesNames.usersManagement,
                    arguments: cubit.users,
                  );
                },
              ),

              SizedBox(height: 30),
              CustomTextButton(title: "Manager privileges", onPressed: () {}),
            ],
          ),
        );
      },
    );
  }
}
