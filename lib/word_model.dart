import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WordModel {
  final String id;
  final String? chinese;
  final String? pinyin;
  final String translation;
  final String category;
  final int reviewCount;
  final int correctCount;
  final int incorrectCount;
  final DateTime? lastReview;
  final int interval;

  WordModel({
    required this.id,
    this.chinese,
    this.pinyin,
    required this.translation,
    required this.category,
    this.reviewCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.lastReview,
    this.interval = 1,
  });

  factory WordModel.fromFirestore(Map<String, dynamic> data, String id) {
    return WordModel(
      id: id,
      chinese: data['chinese'],
      pinyin: data['pinyin'],
      translation: data['translation'] ?? '',
      category: data['category'] ?? '',
      reviewCount: data['reviewCount'] ?? 0,
      correctCount: data['correctCount'] ?? 0,
      incorrectCount: data['incorrectCount'] ?? 0,
      lastReview: (data['lastReview'] as Timestamp?)?.toDate(),
      interval: data['interval'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chinese': chinese,
      'pinyin': pinyin,
      'translation': translation,
      'category': category,
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'lastReview': lastReview != null ? Timestamp.fromDate(lastReview!) : null,
      'interval': interval,
    };
  }

  int get masteryPercent {
    if (reviewCount == 0) return 0;

    // 1. Précision brute (0.0 à 1.0)
    double accuracy = correctCount / reviewCount;

    // 2. Facteur d'expérience (Seniority)
    // On veut qu'à 5 révisions, ce facteur soit d'environ 0.3 (pour donner 30%)
    // Et qu'il tende vers 1.0 avec le temps.
    // La formule : 1 - e^(-0.07 * reviewCount)
    double experienceFactor = 1 - exp(-0.07 * reviewCount);

    // 3. Le "Frein" de haute précision
    // On applique une puissance à l'accuracy pour que
    // la moindre erreur pèse très lourd sur le score final.
    // (0.95^2 = 0.90, donc une petite baisse d'accuracy se ressent fort)
    double stabilityFactor = pow(accuracy, 1.5).toDouble();

    // Calcul final
    double finalScore = stabilityFactor * experienceFactor * 100;

    // Bonus de perfection : Si l'utilisateur a 100% d'accuracy mais peu de reviews,
    // on s'assure qu'il atteigne tes 30% pour un 5/5.
    return finalScore.round().clamp(0, 100);
  }

  Color get masteryColor {
    if (masteryPercent < 25) return Colors.red;
    if (masteryPercent < 50) return Colors.orange;
    if (masteryPercent < 75) return Colors.limeAccent;
    if (masteryPercent < 90) return Colors.green;
    return Colors.deepPurpleAccent;
  }
}
