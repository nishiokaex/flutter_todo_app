import '../todo_model.dart';

class AddTodo {
  final Todo todo;
  AddTodo(this.todo);
}

class ToggleTodo {
  final String id;
  ToggleTodo(this.id);
}

class RemoveTodo {
  final String id;
  RemoveTodo(this.id);
}
