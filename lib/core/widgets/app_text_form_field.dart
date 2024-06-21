import 'package:flutter/material.dart';
import 'package:tasky/core/theming/app_input_decoration.dart';
import 'package:tasky/core/theming/app_text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final bool? isObsecured;
  final TextInputAction? textInputAction;
  final String labelText;
  final TextEditingController? inputController;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const AppTextFormField({
    super.key,
    required this.labelText,
    this.isObsecured,
    this.textInputAction,
    this.validator,
    this.inputController,
    this.maxLines,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObsecured ?? false,
      textInputAction: textInputAction ?? TextInputAction.next,
      decoration: AppInputDecoration.decorateTextInput(labelText, "", suffixIcon),
      controller: inputController,
      validator: validator,
      maxLines: maxLines,
      minLines: 1,
      style: font14GrayNormal,
      keyboardType: keyboardType ?? TextInputType.text,

    );
  }
}
