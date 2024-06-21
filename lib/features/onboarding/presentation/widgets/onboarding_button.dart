import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/services/storage_service.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_button.dart';

class OnboardingButton extends StatefulWidget {
  const OnboardingButton({super.key});

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppButton(
        borderRadius: 10,
        onPress: () async {
          await Get.find<StorageService>().write(AppStrings.kFirstRun, "false");
          Get.offAllNamed(AppRouter.login);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Let's Start",
              style: font19WhiteBold,
            ),
            Image.asset(
              "assets/images/onboarding_arrow.png",
              height: 24.h,
              // width: 30.w,
            )
          ],
        ),
      ),
    );
  }
}
