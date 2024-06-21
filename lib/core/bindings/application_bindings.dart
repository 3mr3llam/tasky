import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/core/network/api_services.dart';
import 'package:tasky/core/services/storage_service.dart';
import 'package:tasky/core/services/token_service.dart';
import 'package:tasky/features/auth/data/repositories/auth_repository.dart';
import 'package:tasky/features/auth/logic/auth_controller.dart';
import 'package:tasky/features/profile/data/adapters/profile_model_adapter.dart';
import 'package:tasky/features/profile/data/data_sources/hive_profile_data_source.dart';
import 'package:tasky/features/profile/data/models/profile_model.dart';
import 'package:tasky/features/profile/data/repositories/profile_repository.dart';
import 'package:tasky/features/profile/logic/profile_controller.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tasky/features/task/data/repositories/task_repository.dart';
import 'package:tasky/features/task/logic/add_task_controller.dart';
import 'package:tasky/features/task/logic/edit_task_controller.dart';
import 'package:tasky/features/tasks/data/adapters/task_model_adapter.dart';
import 'package:tasky/features/tasks/data/data_sources/hive_tasks_data_source.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';

Future setupDependencies() async {
  // init hive
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // register hive adapters
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(ProfileModelAdapter()); // Register the adapter

  final taskBox = await Hive.openBox<TaskModel>(AppStrings.kTaskBox);
  final profileBox = await Hive.openBox<ProfileModel>(AppStrings.kProfileBox);
  // Set up data sources
  final hiveProfileDataSource = HiveProfileDataSource(profileBox);
  final hiveTaskDataSource = HiveTasksDataSource(taskBox);

  // Set up repository
  final connectivity = Connectivity();

  Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  Get.lazyPut<TokenService>(() => TokenService(Get.find()), fenix: true);
  Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);

  Get.lazyPut<ProfileRepository>(
      () => ProfileRepository(Get.find(), hiveProfileDataSource, connectivity),
      fenix: true);
  Get.lazyPut<ProfileController>(() => ProfileController(Get.find()),
      fenix: true);

  Get.lazyPut(
      () => TaskRepository(Get.find(), hiveTaskDataSource, connectivity),
      fenix: true);
  Get.lazyPut(() => EditTaskController(Get.find()), fenix: true);
  Get.lazyPut(() => AddTaskController(Get.find()), fenix: true);

  Get.lazyPut(
      () => TaskRepository(Get.find(), hiveTaskDataSource, connectivity),
      fenix: true);
  Get.lazyPut(() => TasksController(Get.find(), Get.find()), fenix: true);

  Get.lazyPut<AuthRepository>(() => AuthRepository(Get.find()), fenix: true);
  await Get.putAsync<AuthController>(() async {
    return AuthController(Get.find(), Get.find());
  }, permanent: true);
}
