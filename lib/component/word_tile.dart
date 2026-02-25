import 'package:flutter/material.dart';
import '../word_model.dart';
import '../services/tts_services.dart';

class WordTile extends StatelessWidget {
  final WordModel word;
  final Color? categoryColor;
  final int? oldMastery;
  final VoidCallback? onLongPress;

  const WordTile({
    super.key,
    required this.word,
    this.categoryColor,
    this.oldMastery,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final currentMastery = word.masteryPercent;
    final diff = oldMastery != null ? currentMastery - oldMastery! : 0;

    return ListTile(
      onTap: () => speak(word.chinese ?? ''),
      onLongPress: onLongPress,
      leading: Text(
        word.chinese ?? '?',
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          stops: const [0.7, 1.0],
          colors: [Colors.white, Colors.transparent],
        ).createShader(bounds),
        blendMode: BlendMode.dstIn,
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.clip,
          text: TextSpan(
            children: [
              TextSpan(
                text: word.pinyin ?? "No pinyin",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " - ${word.translation}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      subtitle: Text(
        word.category,
        style: TextStyle(
          color: categoryColor?.withValues(alpha: 0.7) ?? Colors.blueGrey,
        ),
      ),
      trailing: _buildMasteryBadge(currentMastery, diff),
    );
  }

  Widget _buildMasteryBadge(int current, int diff) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: word.masteryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: word.masteryColor.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_rounded, size: 12, color: word.masteryColor),
              const SizedBox(width: 4),
              Text(
                "$current%",
                style: TextStyle(
                  color: word.masteryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (diff != 0)
          Text(
            "${diff > 0 ? '+' : ''}$diff%",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: diff > 0 ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
      ],
    );
  }
}
