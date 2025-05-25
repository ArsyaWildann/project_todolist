import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/model/todo_model.dart';

class ToDoListProvider extends ChangeNotifier {
  late Box<TodoModel> _todoBox;

  List<TodoModel> get todos => _todoBox.values.toList();

  ToDoListProvider() {
    _todoBox = Hive.box<TodoModel>('todosBox');
  }

  void addTodo(String title, {DateTime? date, String status = 'To Do'}) {
    final todo = TodoModel(title: title, dueDate: date, status: status);
    _todoBox.add(todo);
    notifyListeners();
  }

  void updateTodo({
    required int index,
    required String title,
    DateTime? dueDate,
    String status = 'To Do',
  }) {
    final todo = _todoBox.getAt(index);
    if (todo != null) {
      todo.title = title;
      todo.dueDate = dueDate;
      todo.status = status;
      todo.save();
      notifyListeners();
    }
  }

  // REVISED: Update status by passing the TodoModel object directly
  void updateStatusByTodo(TodoModel todo, String newStatus) {
    if (todo.status != newStatus) {
      todo.status = newStatus;
      todo.save();
      notifyListeners();
    }
  }

  void removeTodo(int index) {
    _todoBox.deleteAt(index);
    notifyListeners();
  }
}
