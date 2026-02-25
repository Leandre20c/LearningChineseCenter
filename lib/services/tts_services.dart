import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts tts = FlutterTts();

Future<void> speak(String? text) async {
  if (text == null) return;

  await tts.setLanguage("zh-CN");
  await tts.speak(text);
}
