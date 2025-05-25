import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_nav/bottom_nav.dart';
import '../provider/to_do_list_provider.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoListProvider>(context);
    final filteredTodos = todoProvider.todos
        .where(
            (todo) => todo.title.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search tasks...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          cursorColor: Colors.white,
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _query.isEmpty
            ? Center(
                child: Text(
                  'Start typing to search tasks...',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )
            : filteredTodos.isEmpty
                ? Center(
                    child: Text(
                      'No tasks found.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredTodos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      final isDone = todo.status == 'Done';

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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isDone ? TextDecoration.lineThrough : null,
                              color: isDone ? Colors.grey : Colors.black87,
                            ),
                          ),
                          subtitle: todo.dueDate != null
                              ? Text(
                                  DateFormat('EEEE, d MMM yyyy')
                                      .format(todo.dueDate!),
                                  style: TextStyle(
                                    color: isDone
                                        ? Colors.grey
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : null,
                          trailing: Icon(
                            isDone
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isDone ? Colors.green : Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}
