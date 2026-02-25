import 'package:auth_project/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:auth_project/pages/login_register_page.dart';
import 'package:auth_project/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainScreen();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
