import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:tasky/core/network/api_result.dart';
import 'package:tasky/core/network/api_services.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/features/profile/data/data_sources/hive_profile_data_source.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  final ApiClient _apiClient;
  final HiveProfileDataSource _hiveDataSource;
  final Connectivity _connectivity;

  ProfileRepository(this._apiClient, this._hiveDataSource, this._connectivity);

  Future<ApiResult<ProfileModel>> getProfile() async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localProfile = await _hiveDataSource.getProfile();
      return ApiResult.success(localProfile!);
    } else {
      try {
        var profile = await _apiClient.apiService.getProfile();
        _hiveDataSource.saveProfile(profile);
        return ApiResult.success(profile);
      } on DioException catch (e) {
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }

  Future<void> saveProfile(ProfileModel profile) async {
    await _hiveDataSource.saveProfile(profile);
  }
}
