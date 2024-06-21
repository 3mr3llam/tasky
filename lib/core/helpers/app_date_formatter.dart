import 'package:intl/intl.dart';

String formatDateString(String dateString) {
  // Parse the date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  return formattedDate;
}

String formatTaskDate(String dateString) {
  // Parse the date string into a DateTime object
  DateTime dateTime = DateTime.parse(dateString);

  // Format the DateTime object into the desired format
  String formattedDate = DateFormat('dd MMM,yyyy').format(dateTime);

  return formattedDate;
}