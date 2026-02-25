import 'package:auth_project/pages/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:auth_project/word_model.dart';
import 'package:auth_project/category_model.dart';
import 'package:auth_project/component/word_tile.dart';

class RecapPage extends StatefulWidget {
  final List<WordModel> wordList;
  final CategoryModel? category;
  final Map<String, int> oldMasteryScores;
  final int correctAnswerCount;
  final int incorrectAnswerCount;

  const RecapPage({
    super.key,
    required this.wordList,
    this.category,
    required this.oldMasteryScores,
    required this.correctAnswerCount,
    required this.incorrectAnswerCount,
  });

  @override
  State<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  // Déterminer la couleur selon le pourcentage de réussite
  Color getMasteryColor(double ratio) {
    if (ratio < 25) return Colors.red;
    if (ratio < 50) return Colors.orange;
    if (ratio < 75) return Colors.limeAccent;
    if (ratio < 90) return Colors.green;
    return Colors.deepPurpleAccent;
  }

  // Liste des mots révisés
  Widget _wordList() {
    // Supprimer les doublons pour le recap (si un mot a été répété car oublié)
    final uniqueWords = widget.wordList.toSet().toList();

    if (uniqueWords.isEmpty) {
      return const Center(child: Text("No word found."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: uniqueWords.length,
      itemBuilder: (context, index) {
        final word = uniqueWords[index];
        return WordTile(
          word: word,
          categoryColor: widget.category?.flutterColor,
          oldMastery: widget.oldMasteryScores[word.id],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalAnswers =
        widget.correctAnswerCount + widget.incorrectAnswerCount;
    final double accuracy = totalAnswers > 0
        ? (widget.correctAnswerCount / totalAnswers) * 100
        : 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Session Recap")),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Affichage du score de précision de la session
            const Text(
              "Session Accuracy",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              '${accuracy.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: getMasteryColor(accuracy),
              ),
            ),
            const SizedBox(height: 24),

            // Session detail
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    'You studied ${widget.wordList.toSet().length} words from ${widget.category?.name ?? "all categories"}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Details:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    _wordList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
