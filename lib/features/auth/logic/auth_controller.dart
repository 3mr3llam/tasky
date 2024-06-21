import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/core/helpers/app_snackbar.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/core/network/refresh_access_token_response_model.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/services/token_service.dart';
import 'package:tasky/features/auth/data/models/login_model.dart';
import 'package:tasky/features/auth/data/models/register_model.dart';
import 'package:tasky/features/auth/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final TokenService _tokenService;
  final AuthRepository _authRepository;
  var isLoggedIn = false.obs;
  var isFirstRun = true.obs;
  var isLoading = false.obs;

  final TextEditingController loginPhoneController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController registerNameController = TextEditingController();
  final TextEditingController registerYearsExperienceController =
      TextEditingController();
  final TextEditingController registerExpLevelController =
      TextEditingController();
  final TextEditingController registerAddressController =
      TextEditingController();
  final TextEditingController registerPasswordController =
      TextEditingController();
  var phoneNumber = "".obs;
  var selectedExpLevelValue = "fresh".obs;

  String? newToken;

  AuthController(this._tokenService, this._authRepository);

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  @override
  void onClose() {
    super.onClose();
    registerNameController.dispose();
    registerYearsExperienceController.dispose();
    registerExpLevelController.dispose();
    registerAddressController.dispose();
    registerPasswordController.dispose();

    loginPhoneController.dispose();
    loginPasswordController.dispose();
  }

  Future init() async {
    await checkLoginStatus();
    await checkFirstRunStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = await _tokenService.getAccessToken();
    isLoggedIn.value = token != "" ? true : false;
  }

  Future<void> checkFirstRunStatus() async {
    String? value = await _tokenService.getAccessToken();
    isFirstRun.value = (value != null && value != "");
  }

  Future login(String? phoneNumber) async {
    try {
      isLoading.value = true;
      var data = {
        "phone": phoneNumber,
        "password": loginPasswordController.text
      };
      var response = await _authRepository.login(data);
      response.when(success: (LoginModel loginModel) async {
        await _tokenService.saveAccessToken(loginModel.accessToken);
        await _tokenService.saveRefreshToken(loginModel.refreshToken);
        isLoading.value = false;
        await Future.delayed(const Duration(milliseconds: 350));
        Get.offAllNamed(AppRouter.tasks);
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
        isLoading.value = false;
      }, error: (ErrorModel error) {
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
        isLoading.value = false;
      });
      // isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future register() async {
    try {
      isLoading.value = true;
      RegisterModel registerModel = RegisterModel(
          phone: phoneNumber.value,
          password: registerPasswordController.text,
          displayName: registerNameController.text,
          experienceYears: int.parse(registerYearsExperienceController.text),
          address: registerAddressController.text,
          level: selectedExpLevelValue.value);

      var response = await _authRepository.register(registerModel.toJson());
      response.when(success: (LoginModel loginModel) async {
        await _tokenService.saveAccessToken(loginModel.accessToken);
        await _tokenService.saveRefreshToken(loginModel.refreshToken);
        Get.offAllNamed(AppRouter.tasks);
        await Future.delayed(const Duration(milliseconds: 2000));
        isLoading.value = false;
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
        isLoading.value = false;
      }, error: (ErrorModel error) {
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
        isLoading.value = false;
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future logout() async {
    try {
      isLoading.value = true;
      var refreshToken = await _tokenService.getRefreshToken();
      var accessToken = await _tokenService.getAccessToken();
      var response = await _authRepository
          .logout("Bearer $accessToken", {"token": refreshToken!});

      response.when(success: (Map<String, bool> result) async {
        if (result.containsKey("success")) {
          await _tokenService.removeAccessToken();
          await _tokenService.removeRefreshToken();
          isLoading.value = false;
          Get.offAllNamed(AppRouter.login);
          return;
        }
      }, failure: (NetworkExceptions networkExceptions) async {
        NetworkExceptions.getErrorMessage(networkExceptions);
        //AppSnackBar.showInfoSnackBar(title: "", message: exception);
        isLoading.value = false;
        Get.offAllNamed(AppRouter.login);
      }, error: (ErrorModel error) async {
        // AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
        await _tokenService.removeAccessToken();
        await _tokenService.removeRefreshToken();
        Get.offAllNamed(AppRouter.login);
        isLoading.value = false;
      });
    } catch (ex) {
      await _tokenService.removeAccessToken();
      await _tokenService.removeRefreshToken();
      Get.offAndToNamed(AppRouter.login);
      isLoading.value = false;
    }
  }

  Future<String?> fetchNewAccessToken() async {
    try {
      final refreshToken = await Get.find<TokenService>().getRefreshToken();
      final response = await _authRepository.refreshToken(refreshToken!);
      response.when(success: (RefreshAccessTokenResponseModel token) {
        final newAccessToken = token.accessToken;
        Get.find<TokenService>().saveAccessToken(newAccessToken!);
        newToken = newAccessToken;
      }, failure: (NetworkExceptions networkExceptions) {
        NetworkExceptions.getErrorMessage(networkExceptions);
        //AppSnackBar.showInfoSnackBar(title: "", message: exception);
      }, error: (ErrorModel error) {
        //AppSnackBar.showErrorSnackBar(title:"", message: error.message!);
      });
      return newToken;
    } catch (ex) {
      // Get.find<TokenService>().removeAccessToken();
      // Get.find<TokenService>().removeRefreshToken();
      Get.offAllNamed(AppRouter.login);
    }
    return null;
  }
}
