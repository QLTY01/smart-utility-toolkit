class TaskItem {
  final String id;
  final String title;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  TaskItem copyWith({String? id, String? title, bool? isCompleted}) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isCompleted': isCompleted};
  }

  factory TaskItem.fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}
