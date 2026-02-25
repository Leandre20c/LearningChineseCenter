import 'package:auth_project/pages/flashcards_page.dart';
import 'package:flutter/material.dart';
import 'package:auth_project/services/firebase_custom_services.dart';
import '../category_model.dart';
import '../word_model.dart';

enum ReviewMode {
  difficulty,
  oldest,
  newest,
  random;

  String get label => switch (this) {
    ReviewMode.difficulty => 'Difficulty',
    ReviewMode.oldest => 'Oldest',
    ReviewMode.newest => 'Newest',
    ReviewMode.random => 'Random',
  };
}

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final segmentedButtonStyle = SegmentedButton.styleFrom(
    fixedSize: const Size.fromHeight(48),
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.comfortable,
  );

  final CategoriesService _categoriesService = CategoriesService();
  final WordsService _wordsService = WordsService();

  int _wordCountToReview = 10;
  String _selectedWordCount = '10';

  Set<ReviewMode> _selectedModes = {ReviewMode.difficulty};

  Widget _wordCount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Word count",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            style: segmentedButtonStyle,
            segments: const [
              ButtonSegment(value: '5', label: Text('5')),
              ButtonSegment(value: '10', label: Text('10')),
              ButtonSegment(value: '15', label: Text('15')),
              ButtonSegment(value: '20', label: Text('20')),
              ButtonSegment(value: 'All', label: Text('All')),
            ],
            selected: {_selectedWordCount},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedWordCount = newSelection.first;
                if (_selectedWordCount == 'All') {
                  _wordCountToReview = -1;
                } else {
                  _wordCountToReview = int.parse(_selectedWordCount);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _reviewOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Review focus by",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ReviewMode>(
            style: segmentedButtonStyle,
            multiSelectionEnabled: true,
            emptySelectionAllowed: false,
            showSelectedIcon: false,
            segments: ReviewMode.values.map((mode) {
              return ButtonSegment<ReviewMode>(
                value: mode,
                label: Text(
                  mode.label,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            selected: _selectedModes,
            onSelectionChanged: (Set<ReviewMode> newSelection) {
              setState(() {
                if (newSelection.contains(ReviewMode.random) &&
                    !_selectedModes.contains(ReviewMode.random)) {
                  _selectedModes = {ReviewMode.random};
                } else if (newSelection.length > 1 &&
                    newSelection.contains(ReviewMode.random)) {
                  _selectedModes = newSelection..remove(ReviewMode.random);
                } else {
                  _selectedModes = newSelection;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryCards() {
    return SizedBox(
      height: 300,
      child: StreamBuilder<List<CategoryModel>>(
        stream: _categoriesService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No word yet."));
          }

          List<CategoryModel>? catList = snapshot.data;

          if (catList != null) {
            catList.sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
          }

          return Row(
            children: [
              if (catList!.isEmpty)
                const Expanded(child: Center(child: Text("No category found.")))
              else
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _categoryCardWidget(context, null);
                      }

                      final CategoryModel category = catList[index - 1];
                      return _categoryCardWidget(context, category);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _categoryCardWidget(BuildContext context, CategoryModel? category) {
    final String name = category?.name ?? "All";
    final Color borderColor =
        category?.flutterColor.withValues(alpha: 0.5) ??
        Colors.red.withValues(alpha: 0.5);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardPage(
              cardCount: _wordCountToReview,
              category: category,
              selectedModes: _selectedModes,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 250,
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor, width: 1.5),
            ),
            child: StreamBuilder<List<WordModel>>(
              stream: _wordsService.getWords(),
              builder: (context, snapshot) {
                final words = snapshot.data ?? [];
                final count = category == null
                    ? words.length
                    : words.where((w) => w.category == category.name).length;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Text(
                        "$count words",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pratice")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _wordCount(),
            const SizedBox(height: 16),
            _reviewOptions(),
            const Divider(height: 64),
            Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
            const SizedBox(height: 4),
            _categoryCards(),
          ],
        ),
      ),
    );
  }
}
