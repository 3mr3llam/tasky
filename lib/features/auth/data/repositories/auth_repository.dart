import 'package:dio/dio.dart';
import 'package:tasky/core/network/api_result.dart';
import 'package:tasky/core/network/api_services.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/core/network/refresh_access_token_response_model.dart';
import 'package:tasky/features/auth/data/models/login_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(
    this._apiClient,
  );

  Future<ApiResult<LoginModel>> login(Map<String, dynamic> data) async {
    try {
      var response = await _apiClient.apiService.login(data);
      return ApiResult.success(response);
    } on DioException catch (e) {
      var error = ErrorModel.fromJson(e.response!.data);
      return ApiResult.error(error);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<LoginModel>> register(Map<String, dynamic> data) async {
    try {
      var response = await _apiClient.apiService.register(data);
      return ApiResult.success(response);
    } on DioException catch (e) {
      var error = ErrorModel.fromJson(e.response!.data);
      return ApiResult.error(error);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<Map<String, bool>>> logout(String accessToken, Map<String, String> refreshToken, ) async {
    try {
      var response = await _apiClient.apiService.logout(accessToken, refreshToken);
      return ApiResult.success(response);
    } on DioException catch (e) {
      var error = ErrorModel.fromJson(e.response!.data);
      return ApiResult.error(error);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<RefreshAccessTokenResponseModel>> refreshToken(String refreshToken) async {
    try {
      var response = await _apiClient.apiService.refreshAccessToken(refreshToken);
      return ApiResult.success(response);
    } on DioException catch(e) {
      var error = ErrorModel.fromJson(e.response!.data);
      return ApiResult.error(error);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}
