class WordModel {
  final String id;
  final String chinese;
  final String pinyin;
  final String translation;
  final String category;
  final String mastery;

  WordModel({
    required this.id,
    required this.chinese,
    required this.pinyin,
    required this.translation,
    required this.category,
    required this.mastery,
  });

  // Firestore -> Dart
  factory WordModel.fromFirestore(Map<String, dynamic> data, String id) {
    return WordModel(
      id: id,
      chinese: data['chinese'] ?? '',
      pinyin: data['pinyin'] ?? '',
      translation: data['translation'] ?? '',
      category: data['category'] ?? '',
      mastery: data['mastery'] ?? 'new',
    );
  }

  // Dart -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'chinese': chinese,
      'pinyin': pinyin,
      'translation': translation,
      'category': category,
      'mastery': mastery,
    };
  }
}