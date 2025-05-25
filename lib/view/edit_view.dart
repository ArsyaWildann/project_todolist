import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../model/todo_model.dart';
import 'package:todolist/provider/to_do_list_provider.dart';

class EditView extends StatefulWidget {
  const EditView({super.key});

  @override
  State<EditView> createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  bool _isDone = false;
  int? _todoIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final todo = args['todo'] as TodoModel;
    _todoIndex = args['index'] as int;

    _taskController.text = todo.title;
    _selectedDate = todo.dueDate;
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<ToDoListProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.orange[800]),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              Text(
                'Edit Task',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[900],
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _taskController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Task title',
                  filled: true,
                  fillColor: Colors.orange[100],
                  prefixIcon: Icon(Icons.edit, color: Colors.orange[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 5),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.orange[700]),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? 'Select due date'
                            : DateFormat('EEEE, d MMM yyyy')
                                .format(_selectedDate!),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                value: _isDone,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() {
                    _isDone = value ?? false;
                  });
                },
                title: const Text("Mark as done"),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(200, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    final title = _taskController.text.trim();
                    if (title.isNotEmpty && _todoIndex != null) {
                      final status = _isDone ? 'Done' : 'To Do';
                      todoProvider.updateTodo(
                          index: _todoIndex!,
                          title: title,
                          dueDate: _selectedDate,
                          status: status);
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a task name')),
                      );
                    }
                  },
                  child: const Text(
                    'Update Task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
