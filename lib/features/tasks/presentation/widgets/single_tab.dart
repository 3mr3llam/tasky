import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';

class SingleTab extends StatefulWidget {
  final bool selected;
  final String title;
  const SingleTab({super.key, required this.selected, required this.title});

  @override
  State<SingleTab> createState() => _SingleTabState();
}

class _SingleTabState extends State<SingleTab> {
  @override
  Widget build(BuildContext context) {
    var width = context.mediaQuery.size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: width >= 600 ? 10.h : 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color:
            widget.selected ? AppColors.primaryColor : AppColors.veryLightBlue,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Align(
        alignment: Alignment.center,
        child: AppText(
          widget.title,
          style: widget.selected ? font16WhiteBold : font16BlueGrayNormal,
        ),
      ),
    );
  }
}
