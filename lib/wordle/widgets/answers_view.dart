import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/wordle/wordle.dart';

class AnswersView extends StatelessWidget {
  const AnswersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final answers =
        context.select((WordleBloc element) => element.state.answers);
    if (answers.isEmpty) return const CircularProgressIndicator();
    return ListView.builder(
      itemCount: maxTries,
      itemBuilder: (context, index) => AnswerTile(wordleAnswer: answers[index]),
    );
  }
}
