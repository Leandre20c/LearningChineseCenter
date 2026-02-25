import 'package:flutter/material.dart';
import 'package:auth_project/services/firebase_custom_services.dart';
import 'package:auth_project/word_model.dart';
import 'package:auth_project/category_model.dart';
import 'package:auth_project/component/word_tile.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  final TextEditingController _controllerSearchWord = TextEditingController();
  final WordsService _wordsService = WordsService();
  final CategoriesService _categoriesService = CategoriesService();
  final FocusNode _searchFocusNode = FocusNode();

  static final CategoryModel allCategory = CategoryModel(
    id: 'all',
    name: 'All',
    color: 0xFF607D8B,
  );

  bool _isSearching = false;

  String _sortBy = "A-Z";

  final List<CategoryModel> _categories = [allCategory];

  @override
  void initState() {
    super.initState();
    _categoriesService.getCategories().listen((categories) {
      setState(() {
        _categories
          ..clear()
          ..add(allCategory)
          ..addAll(categories);
      });
    });

    // Rebuild on searchbar updates
    _controllerSearchWord.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controllerSearchWord.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  final Set<String> _selectedCategories = {"All"};

  Color _colorForCategory(String categoryName) {
    return _categories
        .firstWhere((c) => c.name == categoryName, orElse: () => allCategory)
        .flutterColor;
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[āáǎà]'), 'a')
        .replaceAll(RegExp(r'[ēéěè]'), 'e')
        .replaceAll(RegExp(r'[īíǐì]'), 'i')
        .replaceAll(RegExp(r'[ōóǒò]'), 'o')
        .replaceAll(RegExp(r'[ūúǔù]'), 'u')
        .replaceAll(RegExp(r'[ǖǘǚǜü]'), 'u');
  }

  Widget _searchWordEntryField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      focusNode: _searchFocusNode,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: '', hintText: 'Search a word...'),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _controllerSearchWord.clear();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _searchFocusNode.requestFocus();
        });
      }
    });
  }

  void _addCategoryPopupBis() {
    final categoryController = TextEditingController();
    String errorMessage = "";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SimpleDialog(
          title: Text("Add a new category"),
          contentPadding: EdgeInsetsGeometry.all(20),
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category name'),
            ),
            const SizedBox(height: 8),
            // Error message
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = categoryController.text.trim();
                  if (name.isEmpty) {
                    setModalState(() => errorMessage = "Name cannot be empty");
                    return;
                  }
                  if (_categories.any((c) => c.name == name)) {
                    setModalState(
                      () => errorMessage = "'$name' already exists",
                    );
                    return;
                  }
                  String normalizedName =
                      name[0].toUpperCase() + name.substring(1).toLowerCase();
                  await _categoriesService.addCategory(normalizedName);
                  Navigator.pop(context);
                },
                child: Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _categoryEditPopup(CategoryModel category) {
    if (category.name == "All") return;

    int selectedColor = category.color;

    final catNameController = TextEditingController(text: category.name);
    String errorMessage = "";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SimpleDialog(
          title: const Text("Edit category"),
          contentPadding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: catNameController,
              decoration: InputDecoration(labelText: "Category name"),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: category.colorPalette.map((colorInt) {
                final isSelected = selectedColor == colorInt;
                return GestureDetector(
                  onTap: () => setModalState(() => selectedColor = colorInt),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(colorInt),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            // Error message
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final newName = catNameController.text.trim();

                  // Validations
                  if (newName.isEmpty) {
                    setModalState(() => errorMessage = "Name cannot be empty");
                    return;
                  }

                  if (_categories.any((c) => c.name == newName) &&
                      (newName != category.name)) {
                    setModalState(
                      () => errorMessage = "'$newName' already exists",
                    );
                    return;
                  }

                  String normalizedName =
                      newName[0].toUpperCase() +
                      newName.substring(1).toLowerCase();
                  await _categoriesService.updateCategory(
                    category.name,
                    normalizedName,
                    color: selectedColor,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await _categoriesService.deleteCategory(category.name);
                  setState(() {
                    _selectedCategories.remove(category.name);
                    if (_selectedCategories.isEmpty) {
                      _selectedCategories.add("All");
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _wordEditPopup(WordModel word) {
    String selectedCategory = word.category;
    final chineseController = TextEditingController(text: word.chinese);
    final pinyinController = TextEditingController(text: word.pinyin);
    final translationController = TextEditingController(text: word.translation);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SimpleDialog(
          title: Text('Edit a word'),
          contentPadding: EdgeInsetsGeometry.all(20),
          children: [
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
            Wrap(
              spacing: 8,
              children: _categories.where((c) => c.name != "All").map((
                category,
              ) {
                final isSelected = selectedCategory == category.name;
                return FilterChip(
                  label: Text(category.name),
                  selected: isSelected,
                  onSelected: (_) =>
                      setModalState(() => selectedCategory = category.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _wordsService.updateWord(
                    WordModel(
                      id: word.id,
                      chinese: chineseController.text.trim(),
                      pinyin: pinyinController.text.trim(),
                      translation: translationController.text.trim(),
                      category: selectedCategory,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Edit"),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await _wordsService.deleteWord(word.id);
                  Navigator.pop(context);
                },
                child: Text("Delete"),
              ),
            ),
          ],
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
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final CategoryModel category = _categories[index];
                    if (category.name == "All") {
                      return const SizedBox.shrink();
                    }
                    final isSelected = selectedCategory == category.name;

                    return FilterChip(
                      label: Text(category.name),
                      selected: isSelected,
                      onSelected: (_) {
                        setModalState(() {
                          selectedCategory = category.name;
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

  Widget _buildFilterTab() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isChecked = _selectedCategories.contains(category.name);

            return CheckboxListTile(
              title: Text(
                category.name,
                style: const TextStyle(color: Colors.white),
              ),
              value: isChecked,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Colors.redAccent,
              onChanged: (bool? value) {
                if (value == null) return;

                setModalState(() {
                  setState(() {
                    if (category.name == "All") {
                      _selectedCategories.clear();
                      _selectedCategories.add("All");
                    } else {
                      _selectedCategories.remove("All");
                      if (value == true) {
                        _selectedCategories.add(category.name);
                      } else {
                        _selectedCategories.remove(category.name);
                        if (_selectedCategories.isEmpty) {
                          _selectedCategories.add("All");
                        }
                      }
                    }
                  });
                });
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSortTab() {
    final sorts = ["A-Z", "Mastery Low", "Mastery High", "Recent"];

    return StatefulBuilder(
      builder: (context, setInternalState) {
        return ListView(
          children: sorts
              .map(
                (s) => RadioListTile<String>(
                  title: Text(s, style: const TextStyle(color: Colors.white)),
                  value: s,
                  groupValue: _sortBy,
                  activeColor: Colors.redAccent,
                  onChanged: (val) {
                    if (val == null) return;

                    setInternalState(() {
                      _sortBy = val;
                    });

                    setState(() {
                      _sortBy = val;
                    });
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  Future<dynamic> _filterPopup() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.red,
                  labelColor: Colors.redAccent,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: "Filters"),
                    Tab(text: "Sort"),
                    Tab(text: "Display"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // 1st Tab
                      _buildFilterTab(),
                      // 2nd Tab
                      _buildSortTab(),
                      // 3rd Tab
                      const Center(
                        child: Text(
                          "Options d'affichage",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ignore: unused_element
  Widget _categoryFilterList() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length + 1, // +1 pour le chip "+"
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _categories.length) {
            return ActionChip(
              label: const Icon(Icons.add, size: 16),
              onPressed: () => _addCategoryPopupBis(),
            );
          }

          // Chips normaux
          final category = _categories[index];
          final isSelected = _selectedCategories.contains(category.name);

          return GestureDetector(
            onLongPress: () => _categoryEditPopup(category),
            child: FilterChip(
              label: Text(category.name),
              selected: isSelected,
              selectedColor: category.flutterColor.withValues(alpha: 0.3),
              side: BorderSide(color: category.flutterColor),
              onSelected: (_) {
                setState(() {
                  if (category.name == "All") {
                    _selectedCategories
                      ..clear()
                      ..add("All");
                  } else {
                    _selectedCategories.remove("All");
                    if (isSelected) {
                      _selectedCategories.remove(category.name);
                      if (_selectedCategories.isEmpty) {
                        _selectedCategories.add("All");
                      }
                    } else {
                      _selectedCategories.add(category.name);
                    }
                  }
                });
              },
            ),
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

          final searchText = _controllerSearchWord.text.toLowerCase();

          final filtered = snapshot.data!.where((word) {
            final matchCategory =
                _selectedCategories.contains("All") ||
                _selectedCategories.contains(word.category);

            final normalizedSearch = _normalize(searchText);

            final matchSearch =
                searchText.isEmpty ||
                _normalize(word.pinyin ?? '').contains(normalizedSearch) ||
                _normalize(word.translation).contains(normalizedSearch) ||
                (word.chinese ?? '').contains(searchText);

            return matchCategory && matchSearch;
          }).toList();

          if (_sortBy == "A-Z") {
            filtered.sort((a, b) => a.translation.compareTo(b.translation));
          }
          if (_sortBy == "Mastery Low") {
            filtered.sort(
              (a, b) => a.masteryPercent.compareTo(b.masteryPercent),
            );
          }
          if (_sortBy == "Mastery High") {
            filtered.sort(
              (a, b) => b.masteryPercent.compareTo(a.masteryPercent),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Words: ${filtered.length} / ${snapshot.data!.length}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              if (filtered.isEmpty)
                const Expanded(child: Center(child: Text("No word found.")))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final word = filtered[index];
                      return WordTile(
                        word: word,
                        categoryColor: _colorForCategory(word.category),
                        onLongPress: () => _wordEditPopup(word),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _isSearching) {
          _toggleSearch();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded),
                      onPressed: () => {_toggleSearch()},
                    ),
                    Expanded(
                      child: _searchWordEntryField(_controllerSearchWord),
                    ),
                  ],
                )
              : Text("Your words"),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: Icon(Icons.add_rounded),
                onPressed: _addWordPopup,
              ),
            if (!_isSearching)
              IconButton(
                icon: Icon(Icons.search_rounded),
                onPressed: () => {_toggleSearch()},
              ),
            IconButton(icon: Icon(Icons.sort_rounded), onPressed: _filterPopup),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[const SizedBox(height: 4), _wordList()],
          ),
        ),
      ),
    );
  }
}
