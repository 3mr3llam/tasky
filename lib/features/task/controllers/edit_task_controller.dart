import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/core/helpers/app_snackbar.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/data/models/upload_image_response_model.dart';
import 'package:tasky/features/task/data/repositories/task_repository.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';

class EditTaskController extends GetxController {
  final TaskRepository _taskRepository;

  TextEditingController editTaskTitleController = TextEditingController();
  TextEditingController editTaskDescController = TextEditingController();
  DateTime newDueDate = DateTime.now();
  final image = Rxn<File?>();
  var uploadedImageId = "".obs;
  final updatedTask = Rxn<TaskModel>();
  final List<String> priorityLevels = [
    'low',
    'medium',
    'high',
  ];

  var selectedValue = "Low".obs;

  final List<String> statusLevels = [
    'inprogress',
    'waiting',
    'finished',
  ];

  var selectedStatus = 'inprogress'.obs;

  var isLoading = false.obs;

  EditTaskController(this._taskRepository);

  @override
  void onClose() {
    super.onClose();
    editTaskDescController.dispose();
    editTaskTitleController.dispose();
  }

  Future editTask(TaskModel oldTask) async {
    TaskModel task = TaskModel(
        id: oldTask.id,
        image: uploadedImageId.value.isEmpty
            ? oldTask.image!
            : uploadedImageId.value,
        title: editTaskTitleController.text,
        desc: editTaskDescController.text,
        priority: selectedValue.value,
        status: selectedStatus.value,
        user: oldTask.user,
        createdAt: oldTask.createdAt,
        updatedAt: newDueDate.toString(),
        v: oldTask.v);
    var response = await _taskRepository.editTaskById(oldTask.id!, task);

    response.when(success: (TaskModel newTask) {
      Get.find<TasksController>().updateTaskInList(newTask, oldTask);
      updatedTask.value = newTask;
      AppSnackBar.showSuccessSnackBar(
          title: "", message: "Updated successfully");
    }, failure: (NetworkExceptions networkExceptions) {
      var exception = NetworkExceptions.getErrorMessage(networkExceptions);
      AppSnackBar.showErrorSnackBar(title: "", message: exception);
    }, error: (ErrorModel error) {
      AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
    });
  }

  Future<bool> uploadImage() async {
    var image = Get.find<EditTaskController>().image.value;

    if (image != null) {
      var response = await _taskRepository.uploadImage(image);
      response.when(success: (UploadImageResponseModel imageURL) {
        uploadedImageId.value = imageURL.image ?? "";

        return true;
        // AppSnackBar.showSuccessSnackBar(title: "", message: "Uploaded Successfully");
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

  Future updateTask(TaskModel oldTask) async {
    isLoading.value = true;
    await Get.find<EditTaskController>().uploadImage();
    await Get.find<EditTaskController>().editTask(oldTask);
    isLoading.value = false;
  }
}
