import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:tasky/core/theming/app_text_styles.dart';
import 'package:tasky/features/task/data/models/task_model.dart';
import 'package:tasky/features/tasks/logic/tasks_controller.dart';
import 'package:tasky/features/tasks/presentation/widgets/task_item.dart';

class TasksList extends StatelessWidget {
  final List<TaskModel> taskList;
  final TasksController taskController;

  const TasksList(
      {super.key, required this.taskList, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return LazyLoadScrollView(
          onEndOfPage: taskController.loadNextPage,
          isLoading: taskController.lastPage,
          child: Obx(
            () {
              // if (taskController.isLoadingAllTasks.value && taskController.isLoading.value) {
              //   return const Center(child: CircularProgressIndicator());
              // } else
              if (taskController.tasks.isEmpty) {
                return Center(
                  child: Text(
                    'There is no tasks. Add new task.',
                    style: font14GrayNormal,
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: taskController.getAllTasks,
                  child: ListView.builder(
                    itemCount: taskList.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      var task = taskList[index];
                      return TaskItem(task: task);
                    },
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
