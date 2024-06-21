import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/widgets/spacing.dart';

class FloatingActionButtons extends StatefulWidget {
  const FloatingActionButtons({super.key});

  @override
  State<FloatingActionButtons> createState() => _FloatingActionButtonsState();
}

class _FloatingActionButtonsState extends State<FloatingActionButtons> {
  String? code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: !Platform.isWindows
          ? _buildQrAndAddActionButtons()
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "add",
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () {
                    Get.toNamed(AppRouter.addTask);
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildQrAndAddActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: "qr",
          shape: const CircleBorder(),
          backgroundColor: AppColors.lightBlue,
          onPressed: () async {
            Get.toNamed(AppRouter.qrCode);
          },
          child: const Icon(
            Icons.qr_code,
            color: AppColors.primaryColor,
          ),
        ),
        verticalSpacing(10.h),
        FloatingActionButton(
          heroTag: "add",
          shape: const CircleBorder(),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Get.toNamed(AppRouter.addTask);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
