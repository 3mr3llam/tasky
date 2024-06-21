import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/spacing.dart';

class OnboardingText extends StatelessWidget {
  const OnboardingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          Text(
            "Task Management & To-Do List",
            style: font24VeyDarkBlueBold,
            textAlign: TextAlign.center,
          ),
          verticalSpacing(16),
          Text(
            "This productive tool is designed to help you better manage your task project-wise conveniently!",
            style: font14GrayNormal,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
