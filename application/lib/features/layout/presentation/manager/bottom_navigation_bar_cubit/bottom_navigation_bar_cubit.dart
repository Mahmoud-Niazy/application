import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/home/presentation/views/home_view.dart';
import 'package:test/features/profile/presentation/views/profile_view.dart';
import 'bottom_navigation_bar_states.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarStates> {
  BottomNavigationBarCubit() : super(BottomNavigationBarInitialState());

  static BottomNavigationBarCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [HomeView(), ProfileView()];
  int currentIndex = 0;

  toggle(int index) {
    currentIndex = index;
    emit(BottomNavigationBarToggleState());
  }
}
