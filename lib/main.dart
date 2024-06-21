import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasky/core/theming/app_colors.dart';
import 'package:tasky/core/bindings/application_bindings.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tasky/tasky_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    // set the windows min width and height
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(700, 600));
  }

  // set the color of th status bar and system navigation bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.primaryColor,
    statusBarColor: AppColors.primaryColor,
  ));

  // setup dependencies
  await setupDependencies();
  // setup screen util
  await ScreenUtil.ensureScreenSize();

  runApp(const TaskyApp());
}
