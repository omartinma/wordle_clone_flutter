import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wordle/wordle/wordle.dart';
import 'package:words_repository/words_repository.dart';

part 'wordle_event.dart';
part 'wordle_state.dart';

class WordleBloc extends Bloc<WordleEvent, WordleState> {
  WordleBloc(this._wordsRepository) : super(const WordleState()) {
    on<WordleFetchRequested>(_fetchRequested);
    on<WordleCurrentAnswerUpdated>(_currentAnswerUpdated);
    on<WordleAnswerSubmitted>(_answerSubmitted);
  }

  final WordsRepository _wordsRepository;

  FutureOr<void> _fetchRequested(
    WordleFetchRequested event,
    Emitter<WordleState> emit,
  ) {
    final word = _wordsRepository.getNextWord();
    emit(
      WordleState(
        wordToGuess: word,
        answers: [
          for (var i = 0; i < 6; i++)
            WordleAnswer(word: '', results: List.filled(5, GuessResult.unknown))
        ],
      ),
    );
  }

  void _currentAnswerUpdated(
    WordleCurrentAnswerUpdated event,
    Emitter<WordleState> emit,
  ) {
    emit(state.copyWith(currentAnswer: event.currentAnswer));
  }

  FutureOr<void> _answerSubmitted(
    WordleAnswerSubmitted event,
    Emitter<WordleState> emit,
  ) {
    final currentAnswer = state.currentAnswer;
    final guessResults = <GuessResult>[];
    for (var i = 0; i < currentAnswer.length; i++) {
      final letterAnswer = currentAnswer[i];
      final letterWordToGuess = state.wordToGuess[i];
      if (letterAnswer == letterWordToGuess) {
        guessResults.add(GuessResult.correct);
      } else if (state.wordToGuess.contains(letterAnswer)) {
        guessResults.add(GuessResult.correctButWrongOrder);
      } else {
        guessResults.add(GuessResult.wrong);
      }
    }

    final wordleAnswer = WordleAnswer(
      word: currentAnswer,
      results: guessResults,
    );

    final newAnswers = List<WordleAnswer>.from(state.answers);
    newAnswers[state.currentTry] = wordleAnswer;

    emit(
      state.copyWith(
        answers: newAnswers,
        currentAnswer: '',
        currentTry: state.currentTry + 1,
      ),
    );
  }
}
