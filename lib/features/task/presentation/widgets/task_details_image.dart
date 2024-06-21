import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/widgets/task_image.dart';
import 'package:tasky/features/task/data/models/task_model.dart';

class TaskDetailsImage extends StatelessWidget {
  final TaskModel task;
  const TaskDetailsImage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: task.id!,
      child: task.image == null ||
              task.image!.isEmpty //|| !AppValidators.validateURL(task.image)
          ? Image.asset(
              "assets/images/tasky_icon.png",
              width: 225.w,
              height: 225.h,
              fit: BoxFit.fitWidth,
            )
          : TaskImage(
              imageUrl: "${EndPoints.host}${EndPoints.images}${task.image!}",
              height: 225.h,
              width: double.infinity,
              errorWidget: Image.asset(
                "assets/images/tasky_icon.png",
                width: double.infinity,
                height: 225.h,
                fit: BoxFit.fitWidth,
              ),
            ),
    );
  }
}
