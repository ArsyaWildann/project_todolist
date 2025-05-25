import 'package:flutter/material.dart';
import '../model/todo_model.dart';

class ToDoListProvider extends ChangeNotifier {
  final List<TodoModel> _todos = [];
  String? _currentUser; // Tambahkan ini

  List<TodoModel> get todos => List.unmodifiable(_todos);
  String? get currentUser => _currentUser; // Getter

  void setCurrentUser(String email) {
    _currentUser = email;
    notifyListeners(); // Panggil ini jika kamu ingin UI merespons
  }

  void addTodo(String title, {DateTime? date, String status = 'To Do'}) {
    _todos.add(TodoModel(
      title: title,
      dueDate: date,
      status: status,
      userEmail: _currentUser ?? '',
    ));
    notifyListeners();
  }

  void updateTodo({
    required int index,
    required String title,
    DateTime? dueDate,
    required String status,
  }) {
    if (index >= 0 && index < _todos.length) {
      _todos[index] = TodoModel(
        title: title,
        dueDate: dueDate,
        status: status,
        userEmail: _currentUser ?? '',
      );
      notifyListeners();
    }
  }

  void updateStatusByTodo(TodoModel todo, String newStatus) {
    final idx = _todos.indexOf(todo);
    if (idx != -1) {
      _todos[idx].status = newStatus;
      notifyListeners();
    }
  }

  void removeTodo(int index) {
    if (index >= 0 && index < _todos.length) {
      _todos.removeAt(index);
      notifyListeners();
    }
  }
}
