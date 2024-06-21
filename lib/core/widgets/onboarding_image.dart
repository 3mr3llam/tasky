import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/helpers/extensions.dart';

class OnboardingImage extends StatelessWidget {
  const OnboardingImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = context.mediaQuery.size;
    return Container(
      width: double.infinity,
      height: size.width >= 600? 640.h : 400.h,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
            image: AssetImage(

              "assets/images/onboarding_art.png",
            ),
            ),
      ),
    );
  }
}
