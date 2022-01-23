import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wordle/app/app.dart';
import 'package:words_repository/words_repository.dart';

class App extends StatelessWidget {
  const App({Key? key, required WordsRepository wordsRepository})
      : _wordsRepository = wordsRepository,
        super(key: key);

  final WordsRepository _wordsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: _wordsRepository)],
      child: const AppView(),
    );
  }
}
