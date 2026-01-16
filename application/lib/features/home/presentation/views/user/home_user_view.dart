import 'package:flutter/material.dart';

class HomeUserView extends StatelessWidget{
  const HomeUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome,"),
        ],
      ),
    );
  }
}