import 'package:flutter/material.dart';
import 'package:auth_project/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_project/pages/home_page.dart';
import 'package:auth_project/pages/flashcards_page.dart';
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
    FlashcardPage(),
    WordsPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_library_rounded),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.translate_rounded),
            label: 'Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.class_rounded),
            label: 'Lessons',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
      ),
    );
  }
}
