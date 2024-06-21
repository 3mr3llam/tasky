import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/helpers/app_date_formatter.dart';
import 'package:tasky/core/helpers/app_validators.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_animated_button.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/app_text_form_field.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/task/logic/add_task_controller.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final AddTaskController addTaskController = Get.find<AddTaskController>();

  late List<String> priorityLevels;
  late String selectedPriorityLevels;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    setState(() {
      priorityLevels = addTaskController.priorityLevels;
      selectedPriorityLevels = addTaskController.selectedValue.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpacing(24.h),
                _buildTaskImagePicker(),
                verticalSpacing(16),
                AppText(
                  "Task title",
                  style: font12GrayNormal,
                ),
                verticalSpacing(8),
                AppTextFormField(
                  labelText: "Enter title here...",
                  isObsecured: false,
                  textInputAction: TextInputAction.next,
                  validator: (value) => AppValidators.validateTextInput(
                      value, "Please enter a title"),
                  inputController: addTaskController.editTaskTitleController,
                  maxLines: null,
                ),
                verticalSpacing(16),
                AppText(
                  "Task Description",
                  style: font12GrayNormal,
                ),
                verticalSpacing(8),
                AppTextFormField(
                  labelText: "Enter description here...",
                  isObsecured: false,
                  textInputAction: TextInputAction.done,
                  validator: (value) => AppValidators.validateTextInput(
                      value, "Please enter a description"),
                  inputController: addTaskController.editTaskDescController,
                  maxLines: null,
                ),
                verticalSpacing(16),
                AppText(
                  "Priority",
                  style: font12GrayNormal,
                ),
                verticalSpacing(8),
                _buildDropDownMenu(),
                verticalSpacing(16),
                AppText(
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
                        isLoading: addTaskController.isLoading.value,
                        onPress: addTaskController.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await addTaskController.addTask();
                                }
                              },
                        text: "Add task",
                      ),
                    );
                  },
                ),
                verticalSpacing(24),
              ],
            ),
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
        "Add task",
        style: font16VeyDarkBlueBold,
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
      addTaskController.image.value = File(pickedImage!.path);
    });
  }

  Widget _buildTaskImagePicker() {
    // return addTaskController.image.value == null
    //     ?
    return InkWell(
      onTap: () {
        pickImage();
      },
      child: Container(
        height: addTaskController.image.value?.path != null ? null : 56.h,
        alignment: Alignment.center,
        decoration: DottedDecoration(
            color: AppColors.primaryColor,
            shape: Shape.box,
            borderRadius: BorderRadius.circular(10)),
        child: addTaskController.image.value?.path != null
            ? (kIsWeb
                ? CachedNetworkImage(
                    imageUrl: addTaskController.image.value!.path,
                    height: 370.h,
                    fit: BoxFit.fill,
                    errorWidget: (context, url, error) {
                      return Image.asset("assets/images/logo_12.png");
                    },
                  )
                : Image.file(
                    addTaskController.image.value!,
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

  Widget _buildDropDownMenu() {
    var width = MediaQuery.of(context).size.width;
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
                'Select priority',
                style: font16PrimaryColorBold,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: priorityLevels
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: AppText(
                  item,
                  style: font16PrimaryColorBold,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: selectedPriorityLevels,
        onChanged: (value) {
          setState(() {
            selectedPriorityLevels = value ?? "Low";
          });
          addTaskController.selectedValue.value = value?.toLowerCase() ?? "";
        },
        buttonStyleData: ButtonStyleData(
          height: width >= 600 ? 90 : 65,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
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
          maxHeight: width >= 600 ? 360 : 200,
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
          height: width >= 600 ? 50 : 40,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // padding: EdgeInsets.only(left: 24.w, right: 10.w, top: 20.h, bottom: 20.h),
        ),
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
      addTaskController.newDueDate.value = date!;
    });
  }

  Widget _buildDatePickButton() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
            AppText(
              // ignore: unnecessary_null_comparison
              addTaskController.newDueDate.value != null
                  ? formatTaskDate(
                      addTaskController.newDueDate.value.toString())
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
