part of 'todo_bloc.dart';

//What actions can happen?
abstract class TodoEvent {}

class LoadTodo extends TodoEvent {}

class AddTodo extends TodoEvent {
  AddTodo({required this.todo});

  final Todo todo;
}

class UpdateTodo extends TodoEvent {
  UpdateTodo({required this.todo});

  final Todo todo;
}

class DeleteTodo extends TodoEvent {
  DeleteTodo({required this.id});

  final String id;
}

class ToggleTodo extends TodoEvent {
  ToggleTodo({required this.id});

  final String id;
}
