import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/theming/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tasky/core/routes/app_router.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      ensureScreenSize: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: context.mediaQuery.copyWith(
                textScaler: context.mediaQuery.textScaler
                    .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.6),
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          initialRoute: AppRouter.onboarding,
          getPages: AppRouter.routes,
          theme: appTheme,
          defaultTransition: Transition.rightToLeft,
        );
      },
    );
  }
}
