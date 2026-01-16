import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CustomIconButton extends StatelessWidget{
  final IconData icon ;
  final Color? color;
  final void Function()? onPressed ;
  final double? size;

  const CustomIconButton({super.key,
    required this.onPressed,
    required this.icon,
    this.color = AppColors.primaryColor,
    this.size,
  });
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: size,
      ),
      onPressed: onPressed,
      color: color,
    );
  }
}