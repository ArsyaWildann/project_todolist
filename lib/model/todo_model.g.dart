// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoModelAdapter extends TypeAdapter<TodoModel> {
  @override
  final int typeId = 0;

  @override
  TodoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoModel(
      title: fields[0] as String,
      dueDate: fields[1] as DateTime?,
      status: fields[2] as String,
      userEmail: fields[3] as String, // ini penting
    );
  }

  @override
  void write(BinaryWriter writer, TodoModel obj) {
    writer
      ..writeByte(4) // sekarang ada 4 fields
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.dueDate)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.userEmail); // tulis userEmail juga
  }

  // hashCode dan == tetap sama
}
