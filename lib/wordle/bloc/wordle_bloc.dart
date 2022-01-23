import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:wordle/wordle/wordle.dart';
import 'package:words_repository/words_repository.dart';

part 'wordle_event.dart';
part 'wordle_state.dart';

const maxTries = 6;
const maxWordLength = 5;

class WordleBloc extends Bloc<WordleEvent, WordleState> {
  WordleBloc(this._wordsRepository) : super(const WordleState()) {
    on<WordleGameStarted>(_gameStarted);
    on<WordleCurrentAnswerUpdated>(_currentAnswerUpdated);
    on<WordleAnswerSubmitted>(_answerSubmitted);
    on<WordleValidAnswerSubmitted>(_validAnswerSubmitted);
  }

  final WordsRepository _wordsRepository;

  FutureOr<void> _gameStarted(
    WordleGameStarted event,
    Emitter<WordleState> emit,
  ) {
    if (state.wordToGuess.isNotEmpty) {
      // You refreshed the game
      emit(state.copyWith(gameStatus: GameStatus.finishedFail));
    }
    final word = _wordsRepository.getNextWord();
    emit(
      WordleState(
        wordToGuess: word,
        answers: [
          for (var i = 0; i < maxTries; i++)
            WordleAnswer(
              word: '',
              results: List.filled(maxWordLength, GuessResult.unknown),
            )
        ],
      ),
    );
  }

  void _currentAnswerUpdated(
    WordleCurrentAnswerUpdated event,
    Emitter<WordleState> emit,
  ) {
    emit(
      state.copyWith(
        currentAnswer: event.currentAnswer,
        gameStatus: GameStatus.playing,
      ),
    );
  }

  FutureOr<void> _answerSubmitted(
    WordleAnswerSubmitted event,
    Emitter<WordleState> emit,
  ) {
    final currentAnswer = state.currentAnswer;
    if (currentAnswer.length < maxWordLength) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.notEnoughCharacters,
        ),
      );
    } else if (!_wordsRepository.wordExists(currentAnswer)) {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.wordNotInDictionary,
        ),
      );
    } else {
      emit(
        state.copyWith(
          submissionStatus: SubmissionStatus.valid,
        ),
      );
    }

    // Clean to avoid duplicates
    emit(state.copyWith(submissionStatus: SubmissionStatus.unknown));
  }

  FutureOr<void> _validAnswerSubmitted(
    WordleValidAnswerSubmitted event,
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
    newAnswers[state.currentTry - 1] = wordleAnswer;

    emit(
      state.copyWith(
        answers: newAnswers,
        currentAnswer: '',
        currentTry: state.currentTry + 1,
      ),
    );

    // Check game status based on current answer
    if (wordleAnswer.isCorrect) {
      emit(state.copyWith(gameStatus: GameStatus.finishedWon));
    } else if (state.currentTry > maxTries) {
      emit(state.copyWith(gameStatus: GameStatus.finishedFail));
    }
  }
}
