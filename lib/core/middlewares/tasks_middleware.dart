import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/routes/app_router.dart';
// import 'package:tasky/core/services/storage_service.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';

class TasksMiddleware extends GetMiddleware {
  @override
  // TODO: implement priority
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    var routeSettings = _getRedirectRoute();

    return RouteSettings(name: routeSettings);
  }

  String? _getRedirectRoute() {
    final authController = Get.put(AuthController(Get.find(), Get.find()));

    final isLoggedIn = authController.isLoggedIn;
    final firstRun = authController.isFirstRun;

    print(isLoggedIn);
    print(firstRun);

    if (firstRun.value == "true") {
      return AppRouter.onboarding;
      //authController.saveFirstRun(false).then((_) {

      // });
    }

    if (isLoggedIn.value == "true") {
      return AppRouter.tasks;
    }

    return AppRouter.login;
  }
}
