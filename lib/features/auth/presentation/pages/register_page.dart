import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/onboarding_image.dart';
import 'package:tasky/features/auth/presentation/widgets/register_form_widget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                const OnboardingImage(),
                Positioned(
                  bottom: 50.h,
                  left: 24.w,
                  child: AppText(
                    "Register",
                    style: font24VeyDarkBlueBold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const RegisterFormWidget(),
            )
          ],
        ),
      ),
    );
  }
}
