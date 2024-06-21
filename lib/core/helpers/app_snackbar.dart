import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';

class AppSnackBar {
  static void showErrorSnackBar({
    required String title,
    required String message,
  }) {
    showSnackBar(
      title: title,
      message: message,
      icon: const Icon(Icons.error_outline, size: 40, color: Colors.red),
      backgroundColor: Colors.red,
    );
  }

  static void showInfoSnackBar({
    required String title,
    required String message,
  }) {
    showSnackBar(
      title: title,
      message: message,
      icon: const Icon(Icons.info_outline, size: 40, color: Colors.blue),
      backgroundColor: Colors.blue,
    );
  }

  static void showSuccessSnackBar({
    required String title,
    required String message,
  }) {
    showSnackBar(
      title: title,
      message: message,
      icon: const Icon(Icons.check_circle_outline_rounded,
          size: 40, color: Colors.green),
      backgroundColor: Colors.green,
    );
  }

  static void showSnackBar(
      {required String title,
      required String message,
      required Widget? icon,
      required Color backgroundColor}) {
    Get.isSnackbarOpen
        ? null
        : Get.snackbar(
            title,
            message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: backgroundColor.withOpacity(0.1),
            titleText: AppText(title, style: font16VeyDarkBlueBold),
            messageText: AppText(message, style: font14VerDarkGreyMedium),
            colorText: backgroundColor,
            borderRadius: 8.0,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            icon: Container(
              child: icon,
            ),
            shouldIconPulse: true,
            duration: const Duration(milliseconds: 1500),
          );
  }
}
