import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';

class AppButton extends StatelessWidget {
  final Widget? child;
  final VoidCallback? onPress;
  final Color? backgroundColor;

  final String? text;
  final double? borderRadius;
  final double? height;

  const AppButton({
    super.key,
    this.borderRadius,
    this.child,
    this.height,
    required this.onPress,
    this.backgroundColor,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all(backgroundColor ?? AppColors.primaryColor),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, height?.h ?? 30.h),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius?.h ?? 12.h),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: child ??
            AppText(
              text!,
              style: font19WhiteBold,
            ),
      ),
    );
  }
}
