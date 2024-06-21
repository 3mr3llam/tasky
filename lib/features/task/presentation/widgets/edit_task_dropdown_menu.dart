import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/logic/edit_task_controller.dart';

// ignore: must_be_immutable
class EditTaskDropdownMenu extends StatefulWidget {
  final List<String> items;
  String selectedItem;
  final String title;
  final String defaultValue;
  final TaskModel task;
  final EditTaskController editTaskController;
  final bool isStatus;

  EditTaskDropdownMenu({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.task,
    required this.editTaskController,
    required this.title,
    required this.defaultValue,
    this.isStatus = false,
  });

  @override
  State<EditTaskDropdownMenu> createState() => _EditTaskDropdownMenuState();
}

class _EditTaskDropdownMenuState extends State<EditTaskDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Icon(Icons.list, size: 24.h, color: AppColors.primaryColor),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: AppText(
                widget.title,
                style: font16PrimaryColorBold,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: AppText(
                  item.capitalized(),
                  style: font16PrimaryColorBold,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: widget.selectedItem,
        onChanged: (value) {
          setState(() {
            widget.selectedItem = value ?? widget.defaultValue;
          });
          if (widget.isStatus) {
            widget.editTaskController.selectedStatus.value = value ?? "";
          } else {
            widget.editTaskController.selectedValue.value = value ?? "";
          }
        },
        buttonStyleData: ButtonStyleData(
          height: 75,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.veryLightBlue,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Image.asset(
            "assets/images/arrow_down.png",
            height: 24.h,
            width: 24.h,
          ),
          iconSize: 24.h,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 260,
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.veryLightBlue,
          ),
          offset: const Offset(0, 17),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // padding: EdgeInsets.only(left: 24.w, right: 10.w, top: 20.h, bottom: 20.h),
        ),
      ),
    );
  }
}
