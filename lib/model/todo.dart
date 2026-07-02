// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,

    this.isDone = false,
  });

  @HiveField(4)
  final String category;

  @HiveField(3)
  final String description;

  @HiveField(5)
  final DateTime dueDate;

  @HiveField(0)
  final String id;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  final String title;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
