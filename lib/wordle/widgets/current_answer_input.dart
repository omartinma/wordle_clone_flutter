import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/wordle/wordle.dart';

class CurrentAnswerInput extends StatefulWidget {
  const CurrentAnswerInput({Key? key}) : super(key: key);

  @override
  State<CurrentAnswerInput> createState() => _CurrentAnswerInputState();
}

class _CurrentAnswerInputState extends State<CurrentAnswerInput> {
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WordleBloc, WordleState>(
      listenWhen: (previous, current) =>
          previous.submissionStatus != current.submissionStatus ||
          previous.gameStatus != current.gameStatus,
      listener: (context, state) {
        if (state.gameStatus == GameStatus.started) {
          textEditingController.clear();
        }
        if (state.submissionStatus == SubmissionStatus.valid) {
          textEditingController.clear();
          context.read<WordleBloc>().add(const WordleValidAnswerSubmitted());
        } else if (state.submissionStatus ==
            SubmissionStatus.notEnoughCharacters) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Not enough characers')),
          );
        } else if (state.submissionStatus ==
            SubmissionStatus.wordNotInDictionary) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Word not in dictionary')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: BlocSelector<WordleBloc, WordleState, GameStatus>(
          selector: (state) => state.gameStatus,
          builder: (context, gameStatus) {
            return TextField(
              autofocus: true,
              enabled: gameStatus == GameStatus.playing ||
                  gameStatus == GameStatus.started,
              inputFormatters: [
                LengthLimitingTextInputFormatter(maxWordLength),
              ],
              onChanged: (value) {
                context
                    .read<WordleBloc>()
                    .add(WordleCurrentAnswerUpdated(value));
              },
              onEditingComplete: () {
                context.read<WordleBloc>().add(const WordleAnswerSubmitted());
              },
              controller: textEditingController,
            );
          },
        ),
      ),
    );
  }
}
