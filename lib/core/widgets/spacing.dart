import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget verticalSpacing(double height) {
  return SizedBox(
    height: height.h,
  );
}

Widget horizontalSpacing(double width) {
  return SizedBox(
    width: width.w,
  );
}
