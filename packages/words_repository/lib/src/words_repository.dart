import 'dart:math';

import 'package:english_words/english_words.dart';

/// {@template words_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class WordsRepository {
  /// {@macro words_repository}
  const WordsRepository();
  static const int _maxSize = 5;

  /// Get next random word
  String getNextWord() {
    // generates a new Random object
    final _random = Random();
    String? nextWord;
    while (nextWord == null) {
      final element = all[_random.nextInt(all.length)];
      if (element.length == _maxSize) {
        nextWord = element;
      }
    }
    return nextWord;
  }

  /// Return whether a word exists or not
  bool wordExists(String word) {
    return all.contains(word);
  }
}
