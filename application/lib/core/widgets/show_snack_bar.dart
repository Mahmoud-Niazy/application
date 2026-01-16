import 'package:flutter/material.dart';
import 'package:test/core/utils/app_colors.dart';

enum SnackBarStatus { error, success, warning }

class CustomSnackBar {
 static void show({
    required BuildContext context,
    required String label,
    required SnackBarStatus status,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(label),
        backgroundColor: status == SnackBarStatus.error
            ? Colors.red
            : status == SnackBarStatus.success
            ? AppColors.primaryColor
            : Colors.orangeAccent,
      ),
    );
  }
}
