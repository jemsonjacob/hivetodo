import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:todo_hive/model/todo.dart';
import 'package:todo_hive/repository/todo_repository.dart';
part 'todo_event.dart';
part 'todo_state.dart';

//The BLoC acts as the mediator (or controller) between Events and States.
//UI-> Event -> Bloc -> State-> UI(updated)
// Events = Things that happened (button clicked, screen opened, delete pressed)
// Bloc = Receives events, executes business logic, calls repositories/services,
// and decides which state to emit
// States = The result that the UI should display

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodo>(_loadTodos);
    on<AddTodo>(_addTodo);
    on<UpdateTodo>(_updateTodo);
    on<DeleteTodo>(_deleteTodo);
    on<ToggleTodo>(_toggleTodo);
  }

  final TodoRepository repository;

  Future<void> _loadTodos(LoadTodo event, Emitter<TodoState> emit) async {
    try {
      final todos = await repository.getTodo();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _addTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      //Why add(LoadTodos())?
      // After adding a todo to the database, we want to reload all todos.
      // AddTodo Event
      //       ↓
      // Save todo in database
      //       ↓
      // LoadTodos Event
      //       ↓
      // Fetch latest list
      //       ↓
      // TodoLoaded(updatedList)
      // We reuse the existing LoadTodos logic instead of writing it again.
      await repository.addTodo(event.todo);
      add(LoadTodo()); //add is used to avoid repeating code using emit
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _updateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.updateTodo(event.todo.id, event.todo);
      add(LoadTodo());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _deleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      await repository.deleteTodo(event.id);
      add(LoadTodo());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  Future<void> _toggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    try {
      if (state is! TodoLoaded) {
        return;
      }

      final current = (state as TodoLoaded).todos;
      final index = current.indexWhere((e) => e.id == event.id);
      if (index == -1) {
        return;
      }

      final todo = current[index];
      final updated = todo.copyWith(isDone: !todo.isDone);
      await repository.updateTodo(todo.id, updated);
      add(LoadTodo());
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }
}
