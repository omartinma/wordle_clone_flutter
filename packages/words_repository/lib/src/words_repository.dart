import 'dart:math';

/// {@template words_repository}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class WordsRepository {
  /// {@macro words_repository}
  const WordsRepository(this._words);
  static const int _maxSize = 5;
  final List<String> _words;

  /// Get next random word
  String getNextWord() {
    // generates a new Random object
    final _random = Random();
    String? nextWord;
    while (nextWord == null) {
      final element = _words[_random.nextInt(_words.length)];
      if (element.length == _maxSize) {
        nextWord = element;
      }
    }
    return nextWord;
  }

  /// Return whether a word exists or not
  bool wordExists(String word) {
    return _words.contains(word);
  }
}
