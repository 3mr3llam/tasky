import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/helpers/app_date_formatter.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_dialog.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/custom_pop_up_menu_divider.dart';
import 'package:tasky/core/widgets/tool_tip_shape.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/presentation/widgets/task_details_image.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  String? qrData;
  QrImage? qrImage;
  late TaskModel task;
  @override
  void initState() {
    super.initState();
    task = Get.arguments['task'] as TaskModel;
    qrData = EndPoints.host + EndPoints.tasks + task.id!;
  }

  @override
  Widget build(BuildContext context) {
    // print(task.image!);
    return Scaffold(
      appBar: _buildAppBar(context, task),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 22.w),
          child: ListView(
            children: [
              TaskDetailsImage(task: task),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(16.h),
                  Text(task.title!, style: font24VeyDarkBlueBold),
                  verticalSpacing(8.h),
                  Text(style: font14GrayNormal, task.desc ?? ""),
                  verticalSpacing(16.h),
                  _buildDateBox(
                      "End Date",
                      formatTaskDate(
                          task.updatedAt ?? DateTime.now().toString())),
                  verticalSpacing(8.h),
                  _buildDetailsBox(
                      task.status! == "inprogress"
                          ? "In progress"
                          : (task.status?.capitalized() ?? ""),
                      false),
                  verticalSpacing(8.h),
                  _buildDetailsBox(
                      "${task.priority!.toLowerCase() == "heigh" || task.priority!.toLowerCase() == "high" ? "High" : (task.priority!.toLowerCase() == "medium" ? "Medium" : "Low")} Priority",
                      true),
                  verticalSpacing(16.h),
                  SizedBox(width: 326.w, height: 326.h, child: _buildQrCode()),
                  // Image.asset("assets/images/qr_code.png",
                  //     width: 326.w, height: 326.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrCode() {
    return Align(
      alignment: Alignment.center,
      child: PrettyQrView.data(data: qrData!),
    );
  }

  Widget _buildDateBox(String title, String subTitle) {
    return ListTile(
      tileColor: AppColors.veryLightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title,
        style: font9GrayNormal,
      ),
      subtitle: Text(
        subTitle,
        style: font14VerDarkBlueNormal,
      ),
      trailing: Image.asset(
        "assets/images/calendar.png",
        width: 24.w,
        height: 24.h,
      ),
    );
  }

  Widget _buildDetailsBox(String title, bool showLeadingIcon) {
    return ListTile(
      tileColor: AppColors.veryLightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      horizontalTitleGap: 10,
      title: AppText(
        title,
        style: font16PrimaryColorBold,
      ),
      minVerticalPadding: 10.w,
      leading: showLeadingIcon
          ? Icon(
              Icons.flag_outlined,
              size: 24.h,
              color: AppColors.primaryColor,
            )
          : null,
      trailing: Image.asset(
        "assets/images/arrow_down.png",
        width: 24.w,
        height: 24.h,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, TaskModel task) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      actions: [
        PopupMenuButton<String>(
          color: Colors.white,
          offset: const Offset(0, 50), // Move the popup menu down by 20 pixels
          shape: const TooltipShape(), // Adjust this value as needed
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          elevation: 15,
          shadowColor: Colors.black54,
          onSelected: (item) {
            onSelected(item, task, context);
          },
          itemBuilder: (context) => [
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
      ],
      leading: IconButton(
        icon: Image.asset(
          "assets/images/arrow_left.png",
          width: 24.h,
          height: 24.h,
        ),
        onPressed: () => context.navigator.pop(),
      ),
      title: AppText(
        "Task details",
        style: font16VeyDarkBlueBold,
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
}
