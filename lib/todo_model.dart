class Todo {
  final String id;
  final String task;
  final bool completed;

  Todo({required this.id, required this.task, this.completed = false});

  Todo copyWith({String? id, String? task, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      completed: completed ?? this.completed,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      task: json['task'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task': task,
      'completed': completed,
    };
  }
}
