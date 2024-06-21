import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/helpers/app_date_formatter.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_animated_button.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/app_text_form_field.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/logic/edit_task_controller.dart';
import 'package:tasky/features/task/presentation/widgets/edit_task_dropdown_menu.dart';
import 'package:tasky/features/task/presentation/widgets/edit_task_image_picker.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({super.key});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final EditTaskController editTaskController = Get.find<EditTaskController>();
  late List<String> priorityLevels;
  late String selectedPriorityLevels;

  late List<String> statusLevels;
  late String selectedStatus;

  late TaskModel task;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();

    setState(() {
      task = Get.arguments['task'] as TaskModel;
      priorityLevels = editTaskController.priorityLevels;
      statusLevels = editTaskController.statusLevels;

      selectedPriorityLevels =
          task.priority != null && task.priority!.isNotEmpty
              ? task.priority!.toLowerCase()
              : editTaskController.selectedValue.toLowerCase();

      selectedStatus = task.status != null && task.status!.isNotEmpty
          ? task.status!.toLowerCase()
          : editTaskController.selectedStatus.toLowerCase();

      editTaskController.editTaskTitleController.text = task.title!;
      editTaskController.editTaskDescController.text = task.desc!;
      editTaskController.newDueDate = DateTime.parse(task.updatedAt!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpacing(24.h),
              EditTaskImagePicker(
                task: task,
                editTaskController: editTaskController,
              ),
              verticalSpacing(16),
              Text(
                "Task title",
                style: font12GrayNormal,
              ),
              verticalSpacing(8),
              AppTextFormField(
                labelText: "Enter title here...",
                isObsecured: false,
                textInputAction: TextInputAction.done,
                inputController: editTaskController.editTaskTitleController,
                maxLines: null,
              ),
              verticalSpacing(16),
              Text(
                "Task Description",
                style: font12GrayNormal,
              ),
              verticalSpacing(8),
              SizedBox(
                // height: 170.h,
                child: AppTextFormField(
                  labelText: "Enter description here...",
                  isObsecured: false,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  inputController: editTaskController.editTaskDescController,
                  maxLines: null,
                ),
              ),
              verticalSpacing(16),
              Text(
                "Status",
                style: font12GrayNormal,
              ),
              verticalSpacing(8),
              EditTaskDropdownMenu(
                title: 'Select stauts',
                defaultValue: 'waiting',
                isStatus: true,
                items: statusLevels,
                selectedItem: selectedStatus,
                task: task,
                editTaskController: editTaskController,
              ),
              verticalSpacing(16),
              Text(
                "Priority",
                style: font12GrayNormal,
              ),
              verticalSpacing(8),
              EditTaskDropdownMenu(
                title: 'Select priority',
                defaultValue: 'low',
                items: priorityLevels,
                selectedItem: selectedPriorityLevels,
                task: task,
                editTaskController: editTaskController,
              ),
              // _buildDropDownMenu(),
              verticalSpacing(16),
              Text(
                "Due date",
                style: font12GrayNormal,
              ),
              verticalSpacing(8),
              _buildDatePickButton(),
              verticalSpacing(24),
              Obx(
                () {
                  return Center(
                    child: AppAnimatedButton(
                      isLoading: editTaskController.isLoading.value,
                      onPress: editTaskController.isLoading.value
                          ? null
                          : () async {
                              await editTaskController.updateTask(task);
                              task = editTaskController.updatedTask.value!;
                            },
                      text: "Edit task",
                    ),
                  );
                },
              ),
              verticalSpacing(24),
            ],
          ),
        ),
      )),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: IconButton(
        icon: Image.asset(
          "assets/images/arrow_left.png",
          width: 24.h,
          height: 24.h,
        ),
        onPressed: () => context.navigator.pop(),
      ),
      title: AppText(
        "Edit task",
        style: font16VeyDarkBlueBold,
      ),
    );
  }

  Future<void> _buildDatePicker(BuildContext context) async {
    var currentDate = DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      currentDate: currentDate,
      firstDate:
          DateTime(currentDate.day, currentDate.month, currentDate.year - 100),
      lastDate: DateTime.now().add(const Duration(days: 1825)),
      builder: (BuildContext context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    16.0), // this is the border radius of the picker
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      editTaskController.newDueDate = date!;
    });
  }

  Widget _buildDatePickButton() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: WidgetStateProperty.all(AppColors.veryLightBlue2),
        minimumSize: WidgetStateProperty.all(
          Size(double.infinity, 30.h),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.h),
              side: const BorderSide(color: AppColors.lightGray)),
        ),
      ),
      onPressed: () => _buildDatePicker(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              // ignore: unnecessary_null_comparison
              editTaskController.newDueDate != null
                  ? formatTaskDate(editTaskController.newDueDate.toString())
                  : 'Choose due date...',
              style: font14GrayishNormal,
            ),
            Image.asset(
              "assets/images/calendar.png",
              width: 24.w,
              height: 24.h,
            ),
          ],
        ),
      ),
    );
  }
}
