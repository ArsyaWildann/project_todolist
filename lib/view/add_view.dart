import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/to_do_list_provider.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedStatus = 'To Do';

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
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.orange[800]),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              Text(
                'Add New Task',
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
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.orange[100],
                  prefixIcon: Icon(Icons.flag, color: Colors.orange[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                  DropdownMenuItem(
                      value: 'In Progress', child: Text('In Progress')),
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
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
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Colors.white,
                            onPrimary: Colors.white,
                            onSurface: Colors.orange.shade900,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
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
                    if (title.isNotEmpty) {
                      todoProvider.addTodo(
                        title,
                        date: _selectedDate,
                        status: _selectedStatus,
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a task name')),
                      );
                    }
                  },
                  child: const Text(
                    'Save Task',
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
