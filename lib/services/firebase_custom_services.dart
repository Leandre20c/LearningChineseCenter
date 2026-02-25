import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../word_model.dart';
import '../category_model.dart';

class WordsService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _wordsRef {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('words');
  }

  Future<void> reviewWord(String wordId, bool correct) async {
    final doc = await _wordsRef.doc(wordId).get();
    final data = doc.data() as Map<String, dynamic>;

    final reviewCount = (data['reviewCount'] ?? 0) + 1;
    final correctCount = (data['correctCount'] ?? 0) + (correct ? 1 : 0);
    final incorrectCount = (data['incorrectCount'] ?? 0) + (correct ? 0 : 1);

    int interval = data['interval'] ?? 1;
    if (correct) {
      interval = (interval * 2).clamp(1, 50);
    } else {
      interval = 1;
    }

    int calculateScore() {
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

    await _wordsRef.doc(wordId).update({
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'lastReview': Timestamp.fromDate(DateTime.now()),
      'interval': interval,
      'mastery': calculateScore(),
    });
  }

  Stream<List<WordModel>> getWords() {
    return _wordsRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => WordModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    });
  }

  Future<List<WordModel>> getWordsOnce() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('words')
        .get();
    return snapshot.docs
        .map((doc) => WordModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<void> addWord(WordModel word) async {
    await _wordsRef.add(word.toMap());
  }

  Future<void> updateWord(WordModel word) async {
    await _wordsRef.doc(word.id).update(word.toMap());
  }

  Future<void> deleteWord(String wordId) async {
    await _wordsRef.doc(wordId).delete();
  }
}

class CategoriesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _categoriesRef {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('categories');
  }

  Stream<List<CategoryModel>> getCategories() {
    return _categoriesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => CategoryModel.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    });
  }

  Future<void> addCategory(String name, {int? color}) async {
    await _categoriesRef.add({'name': name, 'color': color ?? 0xFF607D8B});
  }

  Future<void> deleteCategory(String name) async {
    final snapshot = await _categoriesRef.where('name', isEqualTo: name).get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateCategory(
    String oldName,
    String newName, {
    int? color,
  }) async {
    final snapshot = await _categoriesRef
        .where('name', isEqualTo: oldName)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update({
        'name': newName,
        'color': ?color,
      });
    }

    final uid = _auth.currentUser!.uid;
    final wordsRef = _db.collection('users').doc(uid).collection('words');

    final wordsSnapshot = await wordsRef
        .where('category', isEqualTo: oldName)
        .get();

    final batch = _db.batch();
    for (final doc in wordsSnapshot.docs) {
      batch.update(doc.reference, {'category': newName});
    }
    await batch.commit();
  }
}
