import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class WordleAnswer extends Equatable {
  const WordleAnswer({
    required this.word,
    required this.results,
  });

  final String word;
  final List<GuessResult> results;

  bool get isCorrect {
    return results.every((element) => element == GuessResult.correct);
  }

  @override
  List<Object?> get props => [word, results];
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
