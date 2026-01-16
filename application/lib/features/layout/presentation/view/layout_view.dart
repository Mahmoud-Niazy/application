import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/bottom_navigation_bar_cubit/bottom_navigation_bar_cubit.dart';
import '../manager/bottom_navigation_bar_cubit/bottom_navigation_bar_states.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBarCubit(),
      child: BlocBuilder<BottomNavigationBarCubit, BottomNavigationBarStates>(
        builder: (context, state) {
          var cubit = BottomNavigationBarCubit.get(context);
          return Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,

              onTap: (index) {
                cubit.toggle(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),

                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
