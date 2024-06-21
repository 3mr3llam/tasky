import 'package:get/get.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/core/services/storage_service.dart';

class TokenService extends GetxService {
  final StorageService _storageService;
  String? accessToken;
  String? refreshToken;

  var isFirstTime = true.obs;

  TokenService(this._storageService) {
    getAccessToken();
    checkIsFirstTime();
  }

  Future<void> saveAccessToken(String token) async {
    await _storageService.write(AppStrings.kAccessToken, token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storageService.write(AppStrings.kRefreshToken, token);
  }

  Future<void> saveFirstRun(bool value) async {
    await _storageService.write(AppStrings.kFirstRun, value.toString());
  }

  Future<void> removeAccessToken() async {
    await _storageService.delete(AppStrings.kAccessToken);
    accessToken = null;
  }

  Future<void> removeRefreshToken() async {
    await _storageService.delete(AppStrings.kRefreshToken);
    refreshToken = null;
  }

  Future<String?> getAccessToken() async {
    accessToken = await _storageService.readString(AppStrings.kAccessToken);
    return accessToken;
  }

  Future<String?> getRefreshToken() async {
    var refreshToken =
        await _storageService.readString(AppStrings.kRefreshToken);
    return refreshToken;
  }

  Future<bool> hasKey(String key) async {
    var hasKey = await _storageService.hasKey(key);
    return hasKey;
  }

  Future checkIsFirstTime() async {
    isFirstTime.value = await _storageService.hasKey(AppStrings.kLogin);
  }
}
