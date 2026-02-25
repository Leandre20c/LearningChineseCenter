import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:auth_project/component/flip_card.dart';
import 'package:auth_project/services/firebase_custom_services.dart';
import 'package:auth_project/services/tts_services.dart';
import 'package:auth_project/word_model.dart';
import 'package:auth_project/category_model.dart';
import 'package:auth_project/pages/recap_page.dart';
import 'package:auth_project/pages/practice_page.dart';

const double cardHeight = 500;

class FlashcardPage extends StatefulWidget {
  final CategoryModel? category;
  final int? cardCount;
  final Set<ReviewMode> selectedModes;

  const FlashcardPage({
    super.key,
    this.category,
    this.cardCount,
    required this.selectedModes,
  });

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  final WordsService _wordsService = WordsService();

  int correctAnswer = 0;
  int incorrectAnswer = 0;

  int _currentIndex = 0;
  List<WordModel> _chosenSortedWords = [];
  final Set<String> _failedWordsThisSession = {};
  bool _initialLoadDone = false;
  late final StreamSubscription _wordsSubscription;
  final Map<String, int> _initialMasteryScores = {};
  bool _isProcessing = false;

  Timer? _hintTimer;
  bool _showClickHint = false;

  final GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    _wordsSubscription = _wordsService.getWords().listen((words) {
      if (_initialLoadDone) return;
      final filtered = words.where((word) {
        final matchCategory =
            widget.category == null || word.category == widget.category!.name;
        return matchCategory && word.chinese != null;
      }).toList();
      setState(() {
        final sorted = _applyAdvancedSort(filtered);

        _chosenSortedWords = _choseCardsForReview(
          widget.cardCount,
          sorted,
        );

        for (var word in _chosenSortedWords) {
          _initialMasteryScores[word.id] = word.masteryPercent;
        }

        _initialLoadDone = true;

        Future.delayed(const Duration(milliseconds: 200), () {
          speak(_chosenSortedWords[0].chinese);
        });

        _resetHint();
      });
    });
  }

  @override
  void dispose() {
    _wordsSubscription.cancel();
    super.dispose();
  }

  List<WordModel> _applyAdvancedSort(List<WordModel> words) {
    final sortedWords = [...words];

    if (widget.selectedModes.contains(ReviewMode.random)) {
      sortedWords.shuffle();
      return sortedWords;
    }

    sortedWords.sort((a, b) {
      if (widget.selectedModes.contains(ReviewMode.newest)) {
        if (a.lastReview == null && b.lastReview != null) return -1;
        if (a.lastReview != null && b.lastReview == null) return 1;
      }

      if (widget.selectedModes.contains(ReviewMode.difficulty)) {
        int comp = a.masteryPercent.compareTo(b.masteryPercent);
        if (comp != 0) return comp;
      }

      if (widget.selectedModes.contains(ReviewMode.oldest)) {
        final dateA = a.lastReview ?? DateTime(0);
        final dateB = b.lastReview ?? DateTime(0);
        return dateA.compareTo(dateB);
      }

      return 0;
    });

    return sortedWords;
  }

  void _resetHint() {
    _hintTimer?.cancel();

    setState(() {
      _showClickHint = false;
    });

    _hintTimer = Timer(const Duration(milliseconds: 5000), () {
      if (mounted) {
        setState(() {
          _showClickHint = true;
        });
      }
    });
  }

  List<WordModel> _choseCardsForReview(int? n, List<WordModel> words) {
    if (n == null || n == -1) return words;

    final count = min(n, words.length);

    return words.sublist(0, count);
  }

  Future<void> _nextCard(String wordId, bool correct) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _showClickHint = false;
    });

    await _wordsService.reviewWord(wordId, correct);

    final isLast = _currentIndex == _chosenSortedWords.length - 1;

    _flipCardKey.currentState?.flipToNextNoFade(() async {
      if (isLast) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => RecapPage(
              category: widget.category,
              wordList: _chosenSortedWords.toSet().toList(),
              oldMasteryScores: _initialMasteryScores,
              correctAnswerCount: correctAnswer,
              incorrectAnswerCount: incorrectAnswer,
            ),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          _currentIndex++;
          _isProcessing = false;
          _resetHint();
        });
        speak(_chosenSortedWords[_currentIndex].chinese);
      }
    });
  }

  Widget _cards() {
    if (!_initialLoadDone) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chosenSortedWords.isEmpty) {
      return const Center(child: Text("No word found."));
    }

    final safeIndex = _currentIndex.clamp(0, _chosenSortedWords.length - 1);
    final word = _chosenSortedWords[safeIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.category?.name ?? "All categories"),
        Text(
          '${safeIndex + 1} / ${_chosenSortedWords.length}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Center(
          child: _cardWidget(
            context,
            word.chinese,
            word.pinyin,
            word.translation,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () {
                      final currentWord = _chosenSortedWords[_currentIndex];

                      setState(() {
                        incorrectAnswer += 1;
                        _failedWordsThisSession.add(currentWord.id);
                        _chosenSortedWords.add(currentWord);
                      });

                      _nextCard(word.id, false);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.onError,
                disabledBackgroundColor: Theme.of(
                  context,
                ).colorScheme.onError.withValues(alpha: 0.5),
              ),
              child: Text(
                "    Forget    ",
                style: TextStyle(
                  color: _isProcessing
                      ? Colors.white60
                      : Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () {
                      final currentWord = _chosenSortedWords[_currentIndex];

                      setState(() {
                        if (!_failedWordsThisSession.contains(currentWord.id)) {
                          correctAnswer += 1;
                        }
                      });

                      _nextCard(currentWord.id, true);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade500,
                disabledBackgroundColor: Colors.green.shade500.withValues(
                  alpha: 0.5,
                ),
              ),
              child: Text(
                "Memorised",
                style: TextStyle(
                  color: _isProcessing
                      ? Colors.white60
                      : Theme.of(context).colorScheme.surfaceContainer,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cardWidget(
    BuildContext context,
    String? chinese,
    String? pinyin,
    String translation,
  ) {
    return FlipCard(
      key: _flipCardKey,
      frontBuilder: (opacity) => SizedBox(
        width: 350,
        height: cardHeight,
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: opacity,
                child: SizedBox(
                  height: cardHeight - 8,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              chinese ?? '?',
                              style: const TextStyle(fontSize: 64),
                            ),
                            Text(
                              pinyin ?? '?',
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          height: 20,
                          child: AnimatedOpacity(
                            opacity: _showClickHint ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 1250),
                            curve: Curves.easeInOut,
                            child: Text(
                              "Click to reveal",
                              key: ValueKey('hint_$_currentIndex'),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backBuilder: (opacity) => SizedBox(
        width: 350,
        height: cardHeight,
        child: Card(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                // ← fade uniquement sur le texte
                opacity: opacity,
                child: Text(translation, style: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flashcards")),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_cards()],
          ),
        ),
      ),
    );
  }
}
