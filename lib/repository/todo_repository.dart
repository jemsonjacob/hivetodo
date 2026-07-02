import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/model/todo.dart';

// The Repository acts as a middle layer between
//the BLoC and the data source (API, Hive, SQLite, Firebase, etc.).
// Without a repository:
// UI → Bloc → Hive/API
// With a repository:
// UI → Bloc → Repository → Hive/API
//to clear seperations beacuse bloc should not know about hive methods
//The BLoC should manage state and business logic, not database or API code.

class TodoRepository {
  static const String _todoBoxName = 'todo';

  Future<List<Todo>> getTodo() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Error fetching todo: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final box = await _getBox();

      final newTodo = todo.copyWith();

      await box.put(todo.id, newTodo);
    } catch (e) {
      throw Exception('Error creating todo: $e');
    }
  }

  Future<void> updateTodo(String id, Todo todo) async {
    try {
      final box = await _getBox();

      await box.put(todo.id, todo);
    } catch (e) {
      throw Exception('Error updating todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }

  /// get or create the Hive box for todo
  Future<Box<Todo>> _getBox() async {
    if (Hive.isBoxOpen(_todoBoxName)) {
      return Hive.box<Todo>(_todoBoxName);
    }
    return await Hive.openBox<Todo>(_todoBoxName);
  }
}
