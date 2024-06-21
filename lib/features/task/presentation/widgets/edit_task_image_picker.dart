import 'dart:io';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/core/widgets/task_image.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/logic/edit_task_controller.dart';

class EditTaskImagePicker extends StatefulWidget {
  final TaskModel task;
  final EditTaskController editTaskController;
  const EditTaskImagePicker(
      {super.key, required this.task, required this.editTaskController});

  @override
  State<EditTaskImagePicker> createState() => _EditTaskImagePickerState();
}

class _EditTaskImagePickerState extends State<EditTaskImagePicker> {
  final picker = ImagePicker();
  late String? image;

  @override
  Widget build(BuildContext context) {
    image = widget.editTaskController.image.value?.path ??
        (widget.task.image != null
            ? "${EndPoints.host}${EndPoints.images}${widget.task.image}"
            : null);
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: DottedDecoration(
            color: AppColors.primaryColor,
            shape: Shape.box,
            borderRadius: BorderRadius.circular(10)),
        child: image != null
            ? (kIsWeb || Platform.isAndroid || Platform.isIOS
                ? TaskImage(imageUrl: image, width: 370.w, height: 370.h)
                : Image.file(
                    File(image!),
                    height: 370.h,
                    fit: BoxFit.fill,
                  ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primaryColor,
                    size: 24.h,
                  ),
                  AppText(
                    "Add Image",
                    style: font19PrimaryMedium,
                  )
                ],
              ),
      ),
    );
  }

  Future pickImage() async {
    bool? isCamera = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Camera"),
            ),
            horizontalSpacing(20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Gallery"),
            ),
          ],
        ),
      ),
    );

    if (isCamera == null) return;
    final pickedImage = await picker.pickImage(
        source: isCamera && !Platform.isWindows
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 80,
        maxHeight: 500);
    setState(() {
      image = pickedImage!.path;
      widget.editTaskController.image.value = File(pickedImage.path);
    });
  }
}
