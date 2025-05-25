import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todolist/bottom_nav/bottom_nav.dart';
import 'package:todolist/view/search_view.dart';
import 'model/todo_model.dart';
import 'provider/to_do_list_provider.dart';
import 'splash_screen/splash_screen.dart';
import 'package:todolist/view/home.dart';
import 'package:todolist/view/edit_view.dart';
import 'package:todolist/view/add_view.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const Home(),
        '/add': (context) => const AddView(),
        '/edit': (context) => const EditView(),
        '/bottomnav': (context) => const BottomNav(0),
        '/search': (context) => const SearchView()
      },
    );
  }
}
