import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:wordle/app/app.dart';
import 'package:words_repository/words_repository.dart';

Future<Widget> mainCommon() async {
  const wordsRepository = WordsRepository(all);
  return const App(wordsRepository: wordsRepository);
}
