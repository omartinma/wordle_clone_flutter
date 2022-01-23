import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        onChanged: (value) {
          context.read<WordleBloc>().add(WordleCurrentAnswerUpdated(value));
        },
        onEditingComplete: () {
          context.read<WordleBloc>().add(const WordleAnswerSubmitted());
          textEditingController.clear();
        },
        controller: textEditingController,
      ),
    );
  }
}
