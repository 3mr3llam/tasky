import 'package:flutter/material.dart';

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
    // final double screenWidth = MediaQuery.of(context).size.width;
    return Placeholder(); //EasyButton(
    //     onPressed: widget.onPress,
    //     buttonColor: widget.backgroundColor ?? AppColors.primaryColor,
    //     useWidthAnimation: true,
    //     borderRadius: widget.borderRadius ?? 12,
    //     width: (screenWidth - 40).w,
    //     height: widget.height?.h ?? (screenWidth >= 600 ? 100.h : 50.h),
    //     idleStateWidget: widget.child ??
    //         AppText(
    //           widget.text ?? "",
    //           style: font19WhiteBold,
    //         ),
    //     loadingStateWidget: const CircularProgressIndicator(
    //       strokeWidth: 3,
    //       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //     ));
  }
}
