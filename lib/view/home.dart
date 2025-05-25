import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_nav/bottom_nav.dart';
import '../provider/to_do_list_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> validStatuses = ['To Do', 'In Progress', 'Done'];

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoListProvider>(context);
    final todos =
        todoProvider.todos; // langsung ambil semua, tanpa filter search

    final todosToDo = todos.where((todo) => todo.status == 'To Do').toList();
    final todosInProgress =
        todos.where((todo) => todo.status == 'In Progress').toList();
    final todosDone = todos.where((todo) => todo.status == 'Done').toList();

    Widget buildTaskList(List todos) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final todo = todos[index];
          final isDone = todo.status == 'Done';

          final currentStatus =
              validStatuses.contains(todo.status) ? todo.status : null;

          return Container(
            decoration: BoxDecoration(
              color: isDone ? Colors.orange[50] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              leading: DropdownButton<String>(
                value: currentStatus,
                hint: const Text('Select status'),
                underline: const SizedBox(),
                items: validStatuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    todoProvider.updateStatusByTodo(todo, newStatus);
                  }
                },
              ),
              title: Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : Colors.black87,
                ),
              ),
              subtitle: todo.dueDate != null
                  ? Text(
                      DateFormat('EEEE, d MMM yyyy').format(todo.dueDate!),
                      style: TextStyle(
                        color: isDone ? Colors.grey : Colors.orange[700],
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                    )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit',
                        arguments: {
                          'todo': todo,
                          'index': todoProvider.todos.indexOf(todo),
                        },
                      );
                    },
                    tooltip: 'Edit task',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      final idx = todoProvider.todos.indexOf(todo);
                      if (idx != -1) todoProvider.removeTodo(idx);
                    },
                    tooltip: 'Delete task',
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
        tooltip: 'Add new task',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: todos.isEmpty
            ? Center(
                child: Text(
                  'No tasks yet.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (todosToDo.isNotEmpty) ...[
                      const Text('To Do',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      const SizedBox(height: 8),
                      buildTaskList(todosToDo),
                      const SizedBox(height: 20),
                    ],
                    if (todosInProgress.isNotEmpty) ...[
                      const Text('In Progress',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      const SizedBox(height: 8),
                      buildTaskList(todosInProgress),
                      const SizedBox(height: 20),
                    ],
                    if (todosDone.isNotEmpty) ...[
                      const Text('Done',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange)),
                      const SizedBox(height: 8),
                      buildTaskList(todosDone),
                    ],
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNav(0),
    );
  }
}
