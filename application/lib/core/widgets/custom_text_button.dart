import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final void Function()? onPressed ;


  const CustomTextButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: AppStyles.style13.copyWith(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}