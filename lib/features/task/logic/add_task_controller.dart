import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasky/core/helpers/app_snackbar.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/features/task/data/models/new_task_model.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/data/models/upload_image_response_model.dart';
import 'package:tasky/features/task/data/repositories/task_repository.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';

class AddTaskController extends GetxController {
  final TaskRepository _taskRepository;

  TextEditingController editTaskTitleController = TextEditingController();
  TextEditingController editTaskDescController = TextEditingController();
  var newDueDate = Rxn<DateTime>(); // DateTime.now();
  final image = Rxn<File?>();
  var uploadedImageId = "".obs;
  final updatedTask = Rxn<TaskModel>();
  final List<String> priorityLevels = [
    'low',
    'medium',
    'high',
  ];
  var selectedValue = "low".obs;
  var isLoading = false.obs;

  AddTaskController(this._taskRepository);

  @override
  void onClose() {
    super.onClose();
    editTaskTitleController.dispose();
    editTaskDescController.dispose();
  }

  Future addNewTask() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(newDueDate.value!);
    NewTaskModel task = NewTaskModel(
        image: uploadedImageId.value,
        title: editTaskTitleController.text,
        desc: editTaskDescController.text,
        priority: selectedValue.value.toLowerCase(),
        dueDate: formattedDate);

    var response = await _taskRepository.addNewTask(task);

    response.when(success: (TaskModel newTask) {
      // ignore: invalid_use_of_protected_member
      Get.find<TasksController>().tasks.value.insert(0, newTask);
      Get.find<TasksController>().filterTasks();

      // Get.find<TasksController>().init();
      updatedTask.value = newTask;
      AppSnackBar.showSuccessSnackBar(title: "", message: "Added successfully");
    }, failure: (NetworkExceptions networkExceptions) {
      var exception = NetworkExceptions.getErrorMessage(networkExceptions);
      AppSnackBar.showErrorSnackBar(title: "", message: exception);
    }, error: (ErrorModel error) {
      AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
    });
  }

  Future<bool> uploadImage() async {
    var image = Get.find<AddTaskController>().image.value;
    if (image != null) {
      var response = await _taskRepository.uploadImage(image);
      response.when(success: (UploadImageResponseModel imageURL) {
        uploadedImageId.value = imageURL.image ?? "";
        return true;
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
        return false;
      }, error: (ErrorModel error) {
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
        return false;
      });
    }
    return false;
  }

  Future addTask() async {
    isLoading.value = true;
    await uploadImage();
    await addNewTask();
    isLoading.value = false;
  }
}
