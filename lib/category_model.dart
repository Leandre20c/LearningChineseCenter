import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final int color;

  final List<int> colorPalette = [
    0xFFD81B60, // Rose (Pink 600)
    0xFF8E24AA, // Violet (Purple 600)
    0xFF5E35B1, // Deep Purple (600)
    0xFF3949AB, // Indigo (600)
    0xFF1E88E5, // Bleu (Blue 600)
    0xFF00ACC1, // Cyan (600)
    0xFF00897B, // Teal (600)
    0xFF43A047, // Vert (Green 600)
    0xFFC0CA33, // Lime (600)
    0xFFFDD835, // Jaune (Yellow 600)
    0xFFFB8C00, // Orange (600)
    0xFFF4511E, // Deep Orange (600)
    0xFF6D4C41, // Marron (Brown 600)
    0xFF607D8B, // blueGrey (default)
  ];

  CategoryModel({required this.id, required this.name, required this.color});

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      color: data['color'] ?? 0xFF607D8B,
    );
  }

  Color get flutterColor => Color(color);
}
