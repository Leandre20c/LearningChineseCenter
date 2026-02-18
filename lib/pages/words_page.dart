import 'package:flutter/material.dart';
import 'package:auth_project/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_project/words_service.dart';
import 'package:auth_project/word_model.dart';

class WordsPage extends StatefulWidget {
  WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  final TextEditingController _controllerSearchWord = TextEditingController();
  final WordsService _wordsService = WordsService();

  final List<String> _categories = [
    "All",
    "Family",
    "Food",
    "Numbers",
    "About me",
  ];

  final Set<String> _selectedCategories = {"All"};

  Widget _searchWordEntryField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Find a word',
        hintText: 'Type pinyin or the traduction',
      ),
    );
  }

  Widget _addWordButton() {
    return ElevatedButton(onPressed: _addWordPopup, child: Icon(Icons.add));
  }

  Future<dynamic> _addCategoryPopup() {
    final categoryController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Add a category"),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category name'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final name = categoryController.text.trim();
                    if (name.isNotEmpty && !_categories.contains(name)) {
                      setState(() {
                        _categories.add(name);
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _addWordPopup() {
    String selectedCategory = "Family";
    final chineseController = TextEditingController();
    final pinyinController = TextEditingController();
    final translationController = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add a word"),
              const SizedBox(height: 16),
              TextField(
                controller: chineseController,
                decoration: InputDecoration(labelText: 'Chinese'),
              ),
              TextField(
                controller: pinyinController,
                decoration: InputDecoration(labelText: 'Pinyin'),
              ),
              TextField(
                controller: translationController,
                decoration: InputDecoration(labelText: 'Traduction'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    if (category == "All") {
                      return const SizedBox.shrink();
                    }
                    final isSelected = selectedCategory == category;

                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setModalState(() {
                          selectedCategory = category;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _wordsService.addWord(
                      WordModel(
                        id: '',
                        chinese: chineseController.text.trim(),
                        pinyin: pinyinController.text.trim(),
                        translation: translationController.text.trim(),
                        category: selectedCategory,
                        mastery: 'new',
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryFilterList() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length + 1, // +1 pour le chip "+"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _categories.length) {
            return ActionChip(
              label: const Icon(Icons.add, size: 16),
              onPressed: () {
                _addCategoryPopup();
              },
            );
          }

          // Chips normaux
          final category = _categories[index];
          final isSelected = _selectedCategories.contains(category);

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                if (category == "All") {
                  _selectedCategories
                    ..clear()
                    ..add("All");
                } else {
                  _selectedCategories.remove("All");
                  if (isSelected) {
                    _selectedCategories.remove(category);
                    if (_selectedCategories.isEmpty) {
                      _selectedCategories.add("All");
                    }
                  } else {
                    _selectedCategories.add(category);
                  }
                }
              });
            },
          );
        },
      ),
    );
  }

  Widget _wordList() {
    return Expanded(
      child: StreamBuilder<List<WordModel>>(
        stream: _wordsService.getWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No word yet."));
          }

          final words = snapshot.data!.where((word) {
            return _selectedCategories.contains("All") ||
                _selectedCategories.contains(word.category);
          }).toList();

          // TODO: filter with _controllerSearchWord.value

          if (words.isEmpty) {
            return const Center(child: Text("No word in this category."));
          }

          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return ListTile(
                leading: Text(word.chinese, textScaler: TextScaler.linear(2.5)),
                title: Text('${word.pinyin} · ${word.translation}'),
                subtitle: Text(word.category),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.edit_rounded),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your words"),
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addWordPopup)],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(child: _searchWordEntryField(_controllerSearchWord)),
              ],
            ),
            const SizedBox(height: 16),
            _categoryFilterList(),
            const SizedBox(height: 16),
            _wordList(),
          ],
        ),
      ),
    );
  }
}
