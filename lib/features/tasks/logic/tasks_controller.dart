import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/core/config/app_strings.dart';
import 'package:tasky/core/config/config.dart';
import 'package:tasky/core/config/pagination_filter.dart';
import 'package:tasky/core/helpers/app_snackbar.dart';
import 'package:tasky/core/network/error_model.dart';
import 'package:tasky/core/network/network_exceptions.dart';
import 'package:tasky/core/routes/app_router.dart';
import 'package:tasky/core/services/storage_service.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/task/data/repositories/task_repository.dart';

class TasksController extends GetxController {
  final TaskRepository _taskRepository;
  final StorageService _storageService;

  final tasks = <TaskModel>[].obs;
  final _waitingTasks = <TaskModel>[].obs;
  final _inProgressTasks = <TaskModel>[].obs;
  final _finishedTasks = <TaskModel>[].obs;

  final _paginationFilter = PaginationFilter().obs;
  final _lastPage = false.obs;
  final _accessToken = "".obs;

  var isLoading = false.obs;
  var isLoadingAllTasks = false.obs;

  TasksController(this._taskRepository, this._storageService);

  RxList<TaskModel> get waitingTasks => _waitingTasks;
  RxList<TaskModel> get inProgressTasks => _inProgressTasks;
  RxList<TaskModel> get finishedTasks => _finishedTasks;

  int get limit => _paginationFilter.value.limit;
  int get _page => _paginationFilter.value.page;
  bool get lastPage => _lastPage.value;

  void init() {
    // await _getAccessToken();
    ever(_paginationFilter, (_) => getAllTasks());
    _changePaginationFilter(1, 10);
  }

  Future<void> _getAccessToken() async {
    var token = await _storageService.readString(AppStrings.kAccessToken);
    _accessToken.value = token ?? "";
  }

  Future getTask(String taskId) async {
    if (taskId.contains(EndPoints.host + EndPoints.tasks)) {
      try {
        var linkParts = taskId.split("/");
        isLoading.value = true;
        final tasksData = await _taskRepository.getTask(linkParts.last);
        tasksData.when(success: (TaskModel task) {
          Get.offAndToNamed(AppRouter.taskDetails, arguments: {"task": task});
          isLoading.value = false;
        }, failure: (NetworkExceptions networkExceptions) {
          var exception = NetworkExceptions.getErrorMessage(networkExceptions);
          isLoading.value = false;
          AppSnackBar.showErrorSnackBar(title: "", message: exception);
        }, error: (ErrorModel error) {
          isLoading.value = false;
          AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
        });
      } catch (e) {
        AppSnackBar.showErrorSnackBar(
            title: "", message: "A connection error has occurred");
        isLoading.value = false;
      }
    }
  }

  Future<void> getAllTasks() async {
    try {
      isLoadingAllTasks.value = true;
      isLoading.value = true;
      final tasksData =
          await _taskRepository.getListOfTasks(_paginationFilter.value.page);
      tasksData.when(success: (List<TaskModel> newTasks) {
        if (newTasks.isEmpty) {
          _lastPage.value = true;
        }

        // Create a set of existing task IDs
        final existingTaskIds = tasks.map((task) => task.id).toSet();

        // Filter new tasks to only include those not in the existing list
        final uniqueNewTasks = newTasks
            .where((task) => !existingTaskIds.contains(task.id))
            .toList();

        // Add the unique new tasks to the existing list
        tasks.addAll(uniqueNewTasks);
        filterTasks();
        isLoading.value = false;
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        isLoading.value = false;
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
      }, error: (ErrorModel error) {
        isLoading.value = false;
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
      });
    } catch (e) {
      AppSnackBar.showErrorSnackBar(
          title: "", message: "A connection error has occurred");
      isLoadingAllTasks.value = false;
    }
  }

  Future deleteTask(TaskModel task) async {
    try {
      var response = await _taskRepository.deleteTaskByID(task.id!);
      response.when(success: (_) {
        AppSnackBar.showSuccessSnackBar(
            title: "", message: "Deleted successfully");
        tasks.remove(task);
        filterTasks();
      }, failure: (NetworkExceptions networkExceptions) {
        var exception = NetworkExceptions.getErrorMessage(networkExceptions);
        isLoading.value = false;
        AppSnackBar.showErrorSnackBar(title: "", message: exception);
      }, error: (ErrorModel error) {
        isLoading.value = false;
        AppSnackBar.showErrorSnackBar(title: "", message: error.message!);
      });
    } catch (ex) {
      debugPrint(ex.toString());
      AppSnackBar.showErrorSnackBar(
          title: "", message: "A connection error has occurred");
    }
  }

  void filterTasks() {
    tasks.refresh();
    // ignore: invalid_use_of_protected_member
    _inProgressTasks.value
        .assignAll(tasks.where((task) => task.status == 'inprogress'));
    // ignore: invalid_use_of_protected_member
    _waitingTasks.value
        .assignAll(tasks.where((task) => task.status == 'waiting'));
    // ignore: invalid_use_of_protected_member
    _finishedTasks.value
        .assignAll(tasks.where((task) => task.status == 'finished'));
    _inProgressTasks.refresh();
    _waitingTasks.refresh();
    _finishedTasks.refresh();
  }

  // void changeTotalPerPage(int limitValue) {
  //   tasks.clear();
  //   _lastPage.value = false;
  //   _changePaginationFilter(1, limitValue);
  // }

  void _changePaginationFilter(int page, int limit) {
    _paginationFilter.update((val) {
      val?.page = page;
      val?.limit = limit;
    });
  }

  void loadNextPage() => _changePaginationFilter(_page + 1, limit);

  void updateTaskInList(TaskModel newTask, TaskModel oldTask) {
    var oldTaskID = tasks.indexOf(oldTask);
    tasks.insert(oldTaskID, newTask);
    tasks.removeAt(oldTaskID + 1);
    filterTasks();
  }
}
