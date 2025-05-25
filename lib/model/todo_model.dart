import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime? dueDate;

  @HiveField(2)
  String status;

  @HiveField(3)
  String userEmail;

  TodoModel({
    required this.title,
    this.dueDate,
    this.status = 'To Do',
    required this.userEmail,
  });
}
