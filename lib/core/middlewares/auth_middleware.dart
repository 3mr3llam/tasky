import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/services/token_service.dart';

class AuthMiddleware extends GetMiddleware {
  final _tokenService = Get.find<TokenService>();
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    String? token = _tokenService.accessToken;
    return (token != null) ? const RouteSettings(name: AppRouter.tasks) : null;
  }

  // String? _getAccessTokenSync() {
  //   String? token;
  //   _tokenService.getAccessToken().then((value) {
  //     token = value;
  //   });
  //   return token;
  // }
}
