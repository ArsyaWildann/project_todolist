import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/view/login_view.dart';
import 'package:todolist/view/search_view.dart';
import 'package:todolist/view/signup_view.dart';
import 'model/todo_model.dart';
import 'provider/to_do_list_provider.dart';
import 'view/home.dart';
import 'view/add_view.dart';
import 'view/edit_view.dart';
import 'package:todolist/view/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todosBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ToDoListProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/add': (context) => const AddView(),
        '/edit': (context) => const EditView(),
        '/profile': (context) => const ProfileView(),
        '/search': (context) => const SearchView(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
      },
    );
  }
}
