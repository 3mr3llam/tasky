import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tasky/core/helpers/app_date_formatter.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/widgets/app_dialog.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/custom_pop_up_menu_divider.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/core/widgets/tool_tip_shape.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';
import 'package:tasky/core/widgets/task_image.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/config/config.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  const TaskItem({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRouter.taskDetails, arguments: {"task": task});
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 20.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: TaskImage(
            imageUrl: "${EndPoints.host}${EndPoints.images}${task.image!}",
            title: task.title!,
            width: 64,
            height: 64,
          ),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.title!,
                  style: font16VeyDarkBlueBold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: (task.status! == "waiting")
                      ? AppColors.orange.withOpacity(0.15)
                      : (task.status! == "finished"
                          ? AppColors.primaryColor.withOpacity(0.10)
                          : AppColors.primaryColor.withOpacity(0.15)),
                ),
                child: Text(
                  task.status! == "inprogress"
                      ? "In progress"
                      : task.status!.capitalized(),
                  style: (task.status! == "waiting")
                      ? font12OrangeMedium
                      : (task.status! == "finished"
                          ? font12BlueMedium
                          : font12PrimaryBlueMedium),
                ),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.desc!,
                style: font14VerDarkGreyNormalWith60Opacity,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flag_outlined,
                        color: (task.priority! == "low")
                            ? AppColors.blue
                            : (task.priority! == "medium"
                                ? AppColors.primaryColor
                                : AppColors.orange),
                        size: 16.w),
                    horizontalSpacing(2.h),
                    Text(
                      task.priority! == "heigh"
                          ? "High"
                          : (task.priority != null && task.priority!.isNotEmpty
                              ? task.priority!.capitalized()
                              : ""),
                      style: (task.priority! == "low")
                          ? font12BlueMedium
                          : (task.priority! == "medium"
                              ? font12PrimaryBlueMedium
                              : font12OrangeMedium),
                    ),
                  ],
                ),
                Text(
                  formatDateString(task.createdAt!),
                  style: font12LightGrayNormal,
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          color: Colors.white,
          offset: const Offset(-5, 50), // Move the popup menu down by 20 pixels
          shape: const TooltipShape(), // Adjust this value as needed
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          elevation: 15,
          shadowColor: Colors.black54,
          onSelected: (item) {
            onSelected(item, task, context);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'edit',
              child: AppText(
                'Edit',
                style: font16BlackMedium,
              ),
            ),
            const CustomPopupMenuDivider(
              indent: 15,
              endIndent: 10,
              color: AppColors.verLightGray,
            ),
            PopupMenuItem<String>(
              value: 'delete',
              child: AppText(
                'Delete',
                style: font16OrangeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelected(String item, TaskModel task, BuildContext context) {
    switch (item) {
      case 'edit':
        Get.toNamed(AppRouter.editTask, arguments: {"task": task});
        break;
      case 'delete':
        appDialog(context, "Are you Sure?",
            "Please confirm if you want to delete this task!", () async {
          await Get.find<TasksController>().deleteTask(task);
        }, () {
          Navigator.of(context, rootNavigator: true).pop();
          Get.offNamed(AppRouter.tasks);
        });
        break;
    }
  }

  void onDelete() {
    Get.find<TasksController>().deleteTask(task);
  }
}
