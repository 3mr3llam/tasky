import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/data/repositories/task_repository.dart';
import 'package:tasky/features/task/logic/edit_task_controller.dart';
import 'package:tasky/features/tasks/data/adapters/task_model_adapter.dart';
import 'package:tasky/features/tasks/data/data_sources/hive_tasks_data_source.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class EditTaskBindings implements Bindings {
  @override
  void dependencies() async {
    final connectivity = Connectivity();
    // init hive
    Directory directory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // register hive adapters
    Hive.registerAdapter(TaskModelAdapter());

    final taskBox = await Hive.openBox<TaskModel>(AppStrings.kTaskBox);
    final hiveTaskDataSource = HiveTasksDataSource(taskBox);

    Get.lazyPut(
        () => TaskRepository(Get.find(), hiveTaskDataSource, connectivity));
    Get.lazyPut(() => EditTaskController(Get.find()));
  }
}
