import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hive/bloc/todo_bloc.dart';
import 'package:todo_hive/view/add_task_from.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HiveTodo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [const SizedBox(width: 8)]),
          ),

          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is! TodoLoaded) {
                return const SizedBox();
              }
              final todos = state.todos;
              final pending = todos.where((t) => !t.isDone).length;
              final done = todos.length - pending;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pending: $pending'),
                    Text('Done: $done'),
                    Text('Total: ${todos.length}'),
                  ],
                ),
              );
            },
          ),
          // TODO LIST SECTION
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading || state is TodoInitial) {
                  return Center(child: const CircularProgressIndicator());
                } else if (state is TodoLoaded) {
                  final todos = state.todos;

                  if (todos.isNotEmpty) {
                    return ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];

                        return ListTile(
                          leading: Checkbox(
                            value: todo.isDone,
                            onChanged: (_) {
                              context.read<TodoBloc>().add(
                                ToggleTodo(id: todo.id),
                              );
                            },
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                todo.title,
                                style: TextStyle(
                                  decoration: todo.isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  color: todo.isDone
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              IconButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TaskDetailScreen(task: todo),
                                  ),
                                ),
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              context.read<TodoBloc>().add(
                                DeleteTodo(id: todo.id),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No todos yet"));
                  }
                } else if (state is TodoError) {
                  return Center(child: Text(state.message));
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaskDetailScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
