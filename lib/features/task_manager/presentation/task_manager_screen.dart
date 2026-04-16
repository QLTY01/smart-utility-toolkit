import 'package:flutter/material.dart';
import 'package:smart_utillity_toolkit/features/task_manager/data/task_local_storage.dart';
import 'package:smart_utillity_toolkit/features/task_manager/model/task_item.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final TextEditingController taskController = TextEditingController();
  final TaskLocalStorage localStorage = TaskLocalStorage();

  List<TaskItem> tasks = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final List<TaskItem> savedTasks = await localStorage.loadTasks();

    setState(() {
      tasks = savedTasks;
      isLoading = false;
    });
  }

  Future<void> saveTasks() async {
    await localStorage.saveTasks(tasks);
  }

  Future<void> addTask() async {
    final String title = taskController.text.trim();

    if (title.isEmpty) return;

    final TaskItem newTask = TaskItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isCompleted: false,
    );
    setState(() {
      tasks.add(newTask);
      taskController.clear();
    });

    await saveTasks();
  }

  Future<void> toggleTask(TaskItem task) async {
    setState(() {
      tasks = tasks.map((item) {
        if (item.id == task.id) {
          return item.copyWith(isCompleted: !item.isCompleted);
        }
        return item;
      }).toList();
    });

    await saveTasks();
  }

  Future<void> deleteTask(String taskId) async {
    setState(() {
      tasks.removeWhere((task) => task.id == taskId);
    });

    await saveTasks();
  }

  Future<void> editTask(TaskItem task) async {
    final String? updatedTitle = await showDialog<String>(
      context: context,
      builder: (_) => _EditTaskDialog(initialTitle: task.title),
    );

    if (!mounted || updatedTitle == null) return;

    setState(() {
      tasks = tasks.map((item) {
        if (item.id == task.id) {
          return item.copyWith(title: updatedTitle);
        }
        return item;
      }).toList();
    });

    await saveTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      fillColor: Colors.white,
      filled: true,
    );
  }

  Widget buildTaskItem(TaskItem task) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Checkbox(value: task.isCompleted, onChanged: (_) => toggleTask(task)),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: task.isCompleted ? Colors.black54 : Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: () => editTask(task),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () => deleteTask(task.id),
            icon: const Icon(Icons.delete_outlined),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Your Tasks',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create, complete, edit and delete tasks with offline storage.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: _inputDecoration('Enter a task'),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: addTask,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks yet. Add your first task.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return buildTaskItem(tasks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditTaskDialog extends StatefulWidget {
  const _EditTaskDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<_EditTaskDialog> {
  late final TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: _editController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Task title',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final String updatedTitle = _editController.text.trim();

            if (updatedTitle.isEmpty) return;

            Navigator.of(context).pop(updatedTitle);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
