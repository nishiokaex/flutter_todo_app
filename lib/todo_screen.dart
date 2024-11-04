import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:uuid/uuid.dart';
import 'todo_model.dart';
import 'redux/actions.dart';
import 'redux/reducer.dart';

class TodoScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redux Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Enter a task'),
                  ),
                ),
                StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () {
                      if (_textController.text.isNotEmpty) {
                        store.dispatch(AddTodo(Todo(
                          id: Uuid().v4(),
                          task: _textController.text,
                        )));
                        _textController.clear();
                      }
                    };
                  },
                  builder: (context, callback) {
                    return ElevatedButton(
                      onPressed: callback,
                      child: Text('Add'),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StoreConnector<AppState, List<Todo>>(
              converter: (Store<AppState> store) => store.state.todos,
              builder: (context, todos) {
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(
                        todo.task,
                        style: TextStyle(
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          return () => store.dispatch(ToggleTodo(todo.id));
                        },
                        builder: (context, callback) {
                          return Checkbox(
                            value: todo.completed,
                            onChanged: (_) => callback(),
                          );
                        },
                      ),
                      trailing: StoreConnector<AppState, VoidCallback>(
                        converter: (store) {
                          return () => store.dispatch(RemoveTodo(todo.id));
                        },
                        builder: (context, callback) {
                          return IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: callback,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
