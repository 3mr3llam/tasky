import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';

class AppInputDecoration {
  static decorateTextInput(
      String labelText, String? hintText, Widget? suffixIcon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: font14LightGrayNormal,
      hintText: hintText!,
      hintStyle: font14LightGrayNormal,
      isDense: true,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }

  static decorateDropDownMenu(BuildContext context) {
    // var width = context.mediaQuery.size.width;
    var inputHeight = 20.h;
    return InputDecorationTheme(
      labelStyle: font14LightGrayNormal,
      isDense: true,
      fillColor: Colors.white,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 20.w, vertical: inputHeight),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.lightGray,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.h),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
