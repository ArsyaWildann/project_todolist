import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime? dueDate;

  @HiveField(2)
  String status; // Pastikan ini selalu 'To Do', 'In Progress', atau 'Done'

  TodoModel({
    required this.title,
    this.dueDate,
    this.status = 'To Do',
  });
}
