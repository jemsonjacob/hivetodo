// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

//What can the UI show?
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  TodoLoaded({required this.todos});

  final List<Todo> todos;
}

class TodoError extends TodoState {
  TodoError({required this.message});

  final String message;
}
