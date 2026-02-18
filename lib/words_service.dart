import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'word_model.dart';

class WordsService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Référence à la collection de l'user connecté
  CollectionReference get _wordsRef {
    final uid = _auth.currentUser!.uid;
    return _db.collection('users').doc(uid).collection('words');
  }

  // Lire tous les mots en temps réel (Stream)
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

  // Ajouter un mot
  Future<void> addWord(WordModel word) async {
    await _wordsRef.add(word.toMap());
  }
}
