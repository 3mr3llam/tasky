import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:tasky/core/network/api_result.dart';
import 'package:tasky/core/network/api_services.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/features/task/data/models/new_task_model.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/data/models/upload_image_response_model.dart';
import 'package:tasky/features/tasks/data/data_sources/hive_tasks_data_source.dart';

class TaskRepository {
  final ApiClient _apiClient;
  final HiveTasksDataSource _hiveDataSource;
  final Connectivity _connectivity;

  TaskRepository(
    this._apiClient,
    this._hiveDataSource,
    this._connectivity,
  );

  Future<ApiResult<List<TaskModel>>> getListOfTasks(int page) async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      var localTasks = await _hiveDataSource.getTasks();
      return ApiResult.success(localTasks!);
    } else {
      try {
        var tasks = await _apiClient.apiService.getListOfTasks(page);
        _hiveDataSource.saveTasks(tasks);
        return ApiResult.success(tasks);
      } on dio.DioException catch (e) {
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }

  Future<ApiResult> deleteTaskByID(String taskId) async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return ApiResult.error(ErrorModel("No internet connection", "", 120));
    } else {
      try {
        var response = await _apiClient.apiService.deleteTask(taskId);
        return ApiResult.success(response);
      } on dio.DioException catch (e) {
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }

  Future<ApiResult<TaskModel>> editTaskById(
      String taskId, TaskModel task) async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return ApiResult.error(ErrorModel("No internet connection", "", 120));
    } else {
      try {
        var response =
            await _apiClient.apiService.editTask(taskId, task.toJson());
        return ApiResult.success(response);
      } on dio.DioException catch (e) {
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }

  Future<ApiResult<TaskModel>> addNewTask(NewTaskModel task) async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return ApiResult.error(ErrorModel("No internet connection", "", 120));
    } else {
      try {
        var response = await _apiClient.apiService.addNewTask(task.toJson());
        return ApiResult.success(response);
      } on dio.DioException catch (e) {
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }

  Future<ApiResult<TaskModel>> getTask(String taskId) async {
    try {
      var response = await _apiClient.apiService.getTask(taskId);
      return ApiResult.success(response);
    } on dio.DioException catch (e) {
      var error = ErrorModel.fromJson(e.response!.data);
      return ApiResult.error(error);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadImage(File image) async {
    var connectivityResult = await (_connectivity.checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return ApiResult.error(ErrorModel("No internet connection", "", 120));
    } else {
      try {
        var response = await _apiClient.apiService.uploadImage(
          image,
        );
        return ApiResult.success(response);
      } on dio.DioException catch (e) {
        // print(e.response);
        var error = ErrorModel.fromJson(e.response!.data);
        return ApiResult.error(error);
      } catch (error) {
        return ApiResult.failure(NetworkExceptions.getDioException(error));
      }
    }
  }
}
