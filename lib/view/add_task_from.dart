import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_hive/bloc/todo_bloc.dart';
import 'package:todo_hive/model/todo.dart';

class TaskDetailScreen extends StatefulWidget {
  const TaskDetailScreen({this.task, super.key});

  final Todo? task;

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController categoryController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late TextEditingController titleController;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController = TextEditingController(text: widget.task!.title);
      descriptionController = TextEditingController(
        text: widget.task!.description,
      );
      categoryController = TextEditingController(text: widget.task!.category);
      selectedDate = widget.task!.dueDate;
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      categoryController = TextEditingController();
      selectedDate = DateTime.now().add(const Duration(days: 1));
    }
  }

  void _saveTask() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Title cannot be empty")));
      return;
    }
    // Send TodoAdded event to BLoC.
    context.read<TodoBloc>().add(
      AddTodo(
        todo: Todo(
          id: widget.task?.id ?? DateTime.now().toString(),
          title: titleController.text,
          description: descriptionController.text,
          dueDate: selectedDate,
          isDone: widget.task?.isDone ?? false,
          category: categoryController.text,
        ),
      ),
    );
    // Clear TextField.
    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'New Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Title *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Description
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add details...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Due Date
            const Text(
              'Due Date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate.toString().split(' ')[0]),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Category
            const Text(
              'Category',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                hintText: 'Work, Personal, Learning...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    child: Text(widget.task == null ? 'Create' : 'Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
