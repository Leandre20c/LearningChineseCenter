import 'package:flutter/material.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(
              value: 0,
              label: Text('Words'),
              icon: Icon(Icons.abc),
            ),
            ButtonSegment(
              value: 1,
              label: Text('Collections'),
              icon: Icon(Icons.folder),
            ),
          ],
          selected: {_selectedSegment},
          onSelectionChanged: (value) =>
              setState(() => _selectedSegment = value.first),
        ),
      ],
    );
  }
}
