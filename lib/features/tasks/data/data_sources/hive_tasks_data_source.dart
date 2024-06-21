import 'package:hive/hive.dart';
import 'package:tasky/features/task/data/models/task_model.dart';

class HiveTasksDataSource {
  final Box<TaskModel> taskBox;

  HiveTasksDataSource(this.taskBox);

  Future<List<TaskModel>?> getTasks() async {
    return taskBox.values.toList();
    // return box.values.toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    await taskBox.clear(); // Clear the box to avoid duplicates
    for (var task in tasks) {
      await taskBox.add(task);
    }
  }
}
