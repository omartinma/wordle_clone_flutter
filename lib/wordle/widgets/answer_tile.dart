import 'package:flutter/material.dart';
import 'package:wordle/wordle/wordle.dart';

class AnswerTile extends StatelessWidget {
  const AnswerTile({Key? key, required this.wordleAnswer}) : super(key: key);

  final WordleAnswer wordleAnswer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 5; i++)
          LetterAnswer(
            guessResult: wordleAnswer.results[i],
            letter: wordleAnswer.word.isEmpty ? '' : wordleAnswer.word[i],
          )
      ],
    );
  }
}

class LetterAnswer extends StatelessWidget {
  const LetterAnswer({
    Key? key,
    required this.guessResult,
    required this.letter,
  }) : super(key: key);

  final String letter;
  final GuessResult guessResult;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration:
          BoxDecoration(color: guessResult.color(), border: Border.all()),
      margin: const EdgeInsets.all(3),
      child: Center(child: Text(letter)),
    );
  }
}
