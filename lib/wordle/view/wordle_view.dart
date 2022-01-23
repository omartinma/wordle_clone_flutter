import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/wordle/wordle.dart';

class WordleView extends StatelessWidget {
  const WordleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<WordleBloc>().add(const WordleFetchRequested()),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: const [
          CurrentAnswerInput(),
          SizedBox(height: 30),
          Expanded(child: AnswersView()),
        ],
      ),
    );
  }
}

class NextWord extends StatelessWidget {
  const NextWord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final word =
        context.select((WordleBloc element) => element.state.wordToGuess);
    return Text(word);
  }
}
