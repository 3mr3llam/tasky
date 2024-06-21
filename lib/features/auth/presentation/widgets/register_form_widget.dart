import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky/core/helpers/app_validators.dart';
import 'package:tasky/core/helpers/extensions.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_input_decoration.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_animated_button.dart';
import 'package:tasky/core/widgets/app_text_form_field.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/app_text_span.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';
import 'package:tasky/features/auth/presentation/widgets/register_exp_level_drop_down_menu.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final List<String> dropdownLevelEntries = [
    "fresh",
    "junior",
    "midLevel",
    "senior",
  ];
  late List<DropdownMenuEntry<dynamic>>? experienceLevelEntries;
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = Get.find<AuthController>();

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    experienceLevelEntries = dropdownLevelEntries
        .map(
          (item) => DropdownMenuEntry(
            value: item,
            label: item,
            labelWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child:
                  AppText(item.capitalized(), style: font16PrimaryColorNormal),
            ),
            style: ButtonStyle(
              textStyle: WidgetStateTextStyle.resolveWith(
                (states) => font16PrimaryColorBold,
              ),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          verticalSpacing(24),
          AppTextFormField(
            labelText: "Name",
            isObsecured: false,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            inputController: _authController.registerNameController,
            validator: (value) => AppValidators.validateTextInput(
                value, "Please enter your name"),
          ),
          verticalSpacing(12),
          IntlPhoneField(
            initialCountryCode: 'EG',
            decoration: AppInputDecoration.decorateTextInput(
                "Phone number", "123 456-7890", null),
            disableLengthCheck: true,
            onChanged: (phone) {
              _authController.phoneNumber.value = phone.completeNumber;
            },
            validator: (phone) => AppValidators.validatePhoneNumber(phone),
          ),
          verticalSpacing(12),
          AppTextFormField(
            labelText: "Years of experience",
            isObsecured: false,
            maxLines: 1,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputController: _authController.registerYearsExperienceController,
            validator: (value) => AppValidators.validateTextInput(
                value, "Please enter your years of experience"),
          ),
          verticalSpacing(12),
          Container(
            width: double.infinity,
            height: width >= 600 ? 100.h : 60.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.h),
                border: Border.all(
                  color: AppColors.lightGray,
                )),
            child: RegisterExpLevelDropDownMenu(
              levelsList: dropdownLevelEntries,
              controller: _authController,
            ),
          ),
          // DropdownMenu(
          //    dropdownMenuEntries: experienceLevelEntries!,
          //    controller: _authController.registerExpLevelController,
          //    inputDecorationTheme: AppInputDecoration.decorateDropDownMenu(context),
          //    width: double.infinity,
          //    label: AppText("Choose experience Level", style: font14VerDarkGreyMedium,),
          //    trailingIcon: Icon(Icons.keyboard_arrow_down, size: 24.w,),
          //    selectedTrailingIcon: Icon(Icons.keyboard_arrow_up, size: 24.w,),
          //    textStyle: font14VerDarkBlueNormal,
          //    menuStyle: const MenuStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
          //  ),

          verticalSpacing(12),
          AppTextFormField(
            labelText: "Address",
            isObsecured: false,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            inputController: _authController.registerAddressController,
            validator: (value) => AppValidators.validateTextInput(
                value, "Please enter the address"),
          ),
          verticalSpacing(12),
          AppTextFormField(
            labelText: "Password",
            isObsecured: !_passwordVisible,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            inputController: _authController.registerPasswordController,
            validator: AppValidators.validatePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: _passwordVisible ? AppColors.gray : AppColors.lightGray,
              ),
            ),
          ),
          verticalSpacing(24),
          Obx(
            () {
              return AppAnimatedButton(
                text: Get.find<AuthController>().isLoading.value
                    ? null
                    : "Sign Up",
                isLoading: Get.find<AuthController>().isLoading.value,
                onPress: Get.find<AuthController>().isLoading.value
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          Get.find<AuthController>().register();
                        }
                      },
                child: Get.find<AuthController>().isLoading.value
                    ? SizedBox(
                        width: 27.h,
                        height: 27.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : null,
              );
            },
          ),

          verticalSpacing(24),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.login);
              },
              child: AppTextSpan(
                textSpan: TextSpan(children: [
                  TextSpan(
                      text: "Already have an account?",
                      style: font14GrayNormal),
                  TextSpan(text: " Sign in here", style: font14BlueBold),
                ]),
              ),
            ),
          ),
          verticalSpacing(24),
        ],
      ),
    );
  }
}
