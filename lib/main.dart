import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/bloc/todo_bloc.dart';
import 'package:todo_hive/model/todo.dart';
import 'package:todo_hive/repository/todo_repository.dart';
import 'package:todo_hive/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register adapter
  Hive.registerAdapter(TodoAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //create instances
    final todoRepository = TodoRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TodoRepository>.value(value: todoRepository),
      ],
      child: BlocProvider(
        create: (context) => TodoBloc(todoRepository)..add(LoadTodo()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Todo App',
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
