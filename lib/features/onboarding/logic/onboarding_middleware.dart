import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/services/token_service.dart';

class OnboardingMiddleware extends GetMiddleware {
  final _tokenService = Get.find<TokenService>();

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    var isFirstTime = bool.parse(_tokenService.isFirstTime.value.toString());
    return (!isFirstTime) ? const RouteSettings(name: AppRouter.login) : null;
  }
}
