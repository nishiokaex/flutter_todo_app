import '../todo_model.dart';
import 'actions.dart';

class AppState {
  final List<Todo> todos;

  AppState({required this.todos});
}

AppState appReducer(AppState state, dynamic action) {
  if (action is AddTodo) {
    return AppState(todos: [...state.todos, action.todo]);
  } else if (action is ToggleTodo) {
    return AppState(
      todos: state.todos
          .map((todo) => todo.id == action.id
              ? todo.copyWith(completed: !todo.completed)
              : todo)
          .toList(),
    );
  } else if (action is RemoveTodo) {
    return AppState(
      todos: state.todos.where((todo) => todo.id != action.id).toList(),
    );
  }
  return state;
}
