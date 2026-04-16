import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_utillity_toolkit/features/task_manager/model/task_item.dart';

class TaskLocalStorage {
  static const String tasksKey = 'tasks';
  Future<void> saveTasks(List<TaskItem> tasks) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> taskJsonList = tasks.map((task) {
      return jsonEncode(task.toMap());
    }).toList();

    await prefs.setStringList(tasksKey, taskJsonList);
  }

  Future<List<TaskItem>> loadTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? taskJsonList = prefs.getStringList(tasksKey);

    if (taskJsonList == null) {
      return [];
    }

    return taskJsonList.map((taskJson) {
      final Map<String, dynamic> map =
          jsonDecode(taskJson) as Map<String, dynamic>;
      return TaskItem.fromMap(map);
    }).toList();
  }
}
