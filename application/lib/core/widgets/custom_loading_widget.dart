import 'package:flutter/material.dart';
import 'package:test/core/utils/app_colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor),
    );
  }
}
