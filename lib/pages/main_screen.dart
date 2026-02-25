import 'package:flutter/material.dart';
import 'package:auth_project/pages/home_page.dart';
import 'package:auth_project/pages/practice_page.dart';
import 'package:auth_project/pages/profile_page.dart';
import 'package:auth_project/pages/words_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    WordsPage(),
    PracticePage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.translate_rounded),
            label: 'Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_rounded),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_rounded),
            label: 'Lessons',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
      ),
    );
  }
}
