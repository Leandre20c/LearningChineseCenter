import 'package:flutter/material.dart';
import 'package:auth_project/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:auth_project/reset_and_seed.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await resetAndSeed();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const WidgetTree(),
    );
  }
}
