import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tasky/core/helpers/app_validators.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/theming/app_input_decoration.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/core/widgets/app_animated_button.dart';
import 'package:tasky/core/widgets/app_text.dart';
import 'package:tasky/core/widgets/app_text_form_field.dart';
import 'package:tasky/core/widgets/app_text_span.dart';
import 'package:tasky/core/widgets/spacing.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late AuthController _authController;
  bool _passwordVisible = false;
  late String? phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppText(
              "Login",
              style: font24VeyDarkBlueBold,
            ),
          ),
          verticalSpacing(24),
          IntlPhoneField(
            initialCountryCode: 'EG',
            decoration:
                AppInputDecoration.decorateTextInput("Phone number", "", null),
            textInputAction: TextInputAction.next,
            disableLengthCheck: true,
            style: font14VerDarkBlueNormal,
            controller: _authController.loginPhoneController,
            onChanged: (phone) {
              setState(() {
                phoneNumber = phone.completeNumber;
              });
            },
            validator: (phone) {
              return AppValidators.validatePhoneNumber(phone);
            },
          ),
          verticalSpacing(12),
          AppTextFormField(
            labelText: "Password",
            isObsecured: !_passwordVisible,
            maxLines: 1,
            textInputAction: TextInputAction.done,
            inputController: _authController.loginPasswordController,
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
          Obx(() {
            return AppAnimatedButton(
              text: _authController.isLoading.value ? null : "Sign In",
              isLoading: _authController.isLoading.value,
              onPress: _authController.isLoading.value
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _authController.login(phoneNumber);
                      }
                    },
              child: _authController.isLoading.value
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
          }),
          verticalSpacing(24),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRouter.register);
              },
              child: AppTextSpan(
                textSpan: TextSpan(children: [
                  TextSpan(
                      text: "Don't have any account?", style: font14GrayNormal),
                  TextSpan(text: " Sign up here", style: font14BlueBold),
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
