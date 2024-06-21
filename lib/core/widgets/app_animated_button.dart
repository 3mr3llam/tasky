import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';

class AppAnimatedButton extends StatefulWidget {
  final VoidCallback? onPress;
  final bool isLoading;
  final Color? backgroundColor;
  final String? text;
  final Widget? child;
  final double? borderRadius;
  final double? height;

  const AppAnimatedButton(
      {super.key,
      required this.isLoading,
      required this.onPress,
      this.backgroundColor,
      this.text,
      this.child,
      this.borderRadius,
      this.height});

  @override
  State<AppAnimatedButton> createState() => _AppAnimatedButtonState();
}

class _AppAnimatedButtonState extends State<AppAnimatedButton> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.isLoading ? 50.w : (screenWidth - 40).w,
        height: widget.height?.h ?? (screenWidth >= 600 ? 100.h : 50.h),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(
              widget.isLoading ? 25 : (widget.borderRadius ?? 12)),
        ),
        child: Center(
          child: widget.isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : widget.child ??
                  AppText(
                    widget.text ?? "",
                    style: font19WhiteBold,
                  ),
        ),
      ),
    );
  }
}
