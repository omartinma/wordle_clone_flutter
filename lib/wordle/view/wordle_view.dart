import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/wordle/wordle.dart';

class WordleView extends StatelessWidget {
  const WordleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordleBloc, WordleState>(
      listenWhen: (previous, current) =>
          previous.gameStatus != current.gameStatus,
      listener: (context, state) {
        if (state.gameStatus == GameStatus.finishedFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              key: const Key('wordleView_failedGame_snackBar'),
              content: Text('You failed! The answer was: ${state.wordToGuess}'),
            ),
          );
        } else if (state.gameStatus == GameStatus.finishedWon) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              key: Key('wordleView_wonGame_snackBar'),
              content: Text('You WON!'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wordle'),
          actions: const [RefreshButton()],
        ),
        body: Column(
          children: const [
            CurrentAnswerInput(),
            SizedBox(height: 30),
            Expanded(child: AnswersView()),
          ],
        ),
      ),
    );
  }
}

@visibleForTesting
class RefreshButton extends StatelessWidget {
  const RefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () =>
          context.read<WordleBloc>().add(const WordleGameStarted()),
      icon: const Icon(Icons.refresh),
    );
  }
}
