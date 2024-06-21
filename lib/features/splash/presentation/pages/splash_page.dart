import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.primaryColor,
          child: Center(
            child: Image.asset(
              "assets/images/tasky_logo.png",
              width: 124.w,
              height: 45.h,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }
}
