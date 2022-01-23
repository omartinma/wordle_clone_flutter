import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/wordle/wordle.dart';
import 'package:words_repository/words_repository.dart';

class WordlePage extends StatelessWidget {
  const WordlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WordleBloc(context.read<WordsRepository>())
        ..add(const WordleGameStarted()),
      child: const WordleView(),
    );
  }
}
