import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/widgets/onboarding_image.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/auth/presentation/widgets/login_form_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // overflowAlignment: OverflowBarAlignment.start,
            // spacing: 24.h,
            // overflowSpacing: 16.h,
            // textDirection: TextDirection.ltr,
            children: [
              const OnboardingImage(),
              verticalSpacing(24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const LoginFormWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
