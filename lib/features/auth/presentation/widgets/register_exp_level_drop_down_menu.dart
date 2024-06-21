import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';

class RegisterExpLevelDropDownMenu extends StatefulWidget {
  final List<String> levelsList;
  final AuthController controller;

  const RegisterExpLevelDropDownMenu(
      {super.key, required this.levelsList, required this.controller});

  @override
  State<RegisterExpLevelDropDownMenu> createState() =>
      _RegisterExpLevelDropDownMenuState();
}

class _RegisterExpLevelDropDownMenuState
    extends State<RegisterExpLevelDropDownMenu> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: _selectedValue,
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300.h,
          elevation: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
          offset: const Offset(0, -10),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        buttonStyleData: ButtonStyleData(
          height: 65,
          width: double.infinity,
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 24.h,
            color: AppColors.grayish,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        hint: AppText(
          'Choose experience Level',
          style: font14VerDarkGreyMedium,
          textOverflow: TextOverflow.ellipsis,
        ),
        style: font14GrayNormal,
        onChanged: (String? newValue) {
          setState(() {
            _selectedValue = newValue;
            widget.controller.selectedExpLevelValue.value =
                newValue?.toLowerCase() ?? "fresh";
          });
        },
        items: widget.levelsList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: AppText(
                value.capitalized(),
                style: font14GrayNormal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
