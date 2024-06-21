import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/helpers/app_validators.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TaskImage extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final double width;
  final double height;
  final Widget? errorWidget;
  final bool isCoverFit;

  const TaskImage({
    super.key,
    required this.imageUrl,
    this.title,
    required this.width,
    required this.height,
    this.errorWidget,
    this.isCoverFit = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return AppValidators.validateURL(imageUrl!)
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width.w,
              height: height.w,
              fit: isCoverFit ? BoxFit.cover : BoxFit.contain,
              errorWidget: (context, url, error) {
                return errorWidget ?? Image.asset("assets/images/logo_12.png");
              },
            )
          : Image.file(
              File(imageUrl!),
              height: 370.h,
            );
    } catch (e) {
      //log(e.toString());
    }

    return errorWidget ??
        Container(
          height: width.w,
          width: height.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: AppColors.lightBlue, shape: BoxShape.circle),
          child: Text(
            title!.characters.first.capitalized(),
            style: font16BlueBold,
          ),
        );
  }
}
