import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// We'll define these in separate files, but for simplicity, I'm including them here
import 'todo_model.dart';
import 'redux/actions.dart';
import 'redux/reducer.dart';
import 'todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? storedTodos = prefs.getString('todos');
  final List<Todo> initialTodos = storedTodos != null
      ? (json.decode(storedTodos) as List)
          .map((item) => Todo.fromJson(item))
          .toList()
      : [];

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(todos: initialTodos),
    middleware: persistenceMiddleware(prefs),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Redux Todo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: TodoScreen(),
      ),
    );
  }
}

// Middleware to persist todos to SharedPreferences
List<Middleware<AppState>> persistenceMiddleware(SharedPreferences prefs) {
  return [
    (Store<AppState> store, action, NextDispatcher next) {
      next(action);

      if (action is AddTodo || action is ToggleTodo || action is RemoveTodo) {
        final String encodedTodos = json
            .encode(store.state.todos.map((todo) => todo.toJson()).toList());
        prefs.setString('todos', encodedTodos);
      }
    },
  ];
}
