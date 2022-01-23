import 'package:flutter/material.dart';

class WordleAnswer {
  const WordleAnswer({
    required this.word,
    required this.results,
  });

  final String word;
  final List<GuessResult> results;

  bool get isCorrect {
    return results.every((element) => element == GuessResult.correct);
  }

  WordleAnswer copyWith({
    String? word,
    List<GuessResult>? results,
  }) {
    return WordleAnswer(
      word: word ?? this.word,
      results: results ?? this.results,
    );
  }
}

enum GuessResult {
  wrong,
  correct,
  correctButWrongOrder,
  unknown,
}

extension GuessResultExtension on GuessResult {
  Color color() {
    switch (this) {
      case GuessResult.wrong:
        return Colors.transparent;
      case GuessResult.correct:
        return Colors.green;
      case GuessResult.correctButWrongOrder:
        return Colors.yellow;

      case GuessResult.unknown:
        return Colors.transparent;
    }
  }
}
