import 'package:intl_phone_field/phone_number.dart';

class AppValidators {
  static String? validateTextInput(String? name, String errorMsg) {
    if (name == null || name.isEmpty) {
      return errorMsg;
    }
    return null;
  }

  static String? validatePhoneNumber(PhoneNumber? phoneNumber) {
    if (phoneNumber == null || phoneNumber.completeNumber.isEmpty) {
      return 'Please enter a correct phone number';
    }
    if (!RegExp(r'^\+\d{1,3}\d{4,14}$').hasMatch(phoneNumber.completeNumber)) {
      return 'Incorrect phone number';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password cannot be less than 6 characters';
    }
    return null;
  }

  static bool validateURL(String? url) {
    // return Uri.tryParse(url!)?.hasAbsolutePath ?? false;
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    return (url!.isNotEmpty && regExp.hasMatch(url));
  }
}
