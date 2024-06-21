import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/features/tasks/presentation/widgets/single_tab.dart';

class TasksBody extends StatefulWidget {
  final TabController tabController;
  final int selectedIndex;
  final List<String> tabsTitles;

  const TasksBody(
      {super.key,
      required this.tabController,
      required this.selectedIndex,
      required this.tabsTitles});
  @override
  State<TasksBody> createState() => _TasksBodyState();
}

class _TasksBodyState extends State<TasksBody> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      padding: EdgeInsets.zero,
      indicatorPadding: EdgeInsets.zero,
      dividerColor: Colors.transparent,
      tabAlignment: TabAlignment.start,
      labelPadding: EdgeInsets.symmetric(horizontal: 4.w),
      labelStyle: font16WhiteBold,
      unselectedLabelColor: AppColors.gray,
      unselectedLabelStyle: font16BlueGrayNormal,
      indicatorSize: TabBarIndicatorSize.label,
      isScrollable: true,
      textScaler: TextScaler.noScaling,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      splashBorderRadius: BorderRadius.circular(50.h),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(50.h),
        color: AppColors.primaryColor,
      ),
      controller: widget.tabController,
      tabs: widget.tabsTitles
          .asMap()
          .map(
            (index, title) => MapEntry(
              index,
              SingleTab(
                selected: widget.selectedIndex == index ? true : false,
                title: title,
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
