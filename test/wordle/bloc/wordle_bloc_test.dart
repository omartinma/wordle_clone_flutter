// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wordle/wordle/wordle.dart';
import 'package:words_repository/words_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('WordleBloc', () {
    late WordsRepository wordsRepository;

    setUp(() {
      wordsRepository = MockWordsRepository();
    });

    test('initial state is WordleState', () {
      final state = WordleBloc(wordsRepository).state;
      expect(state, equals(WordleState()));
    });

    group('WordleGameStarted', () {
      blocTest<WordleBloc, WordleState>(
        'emits new game '
        'if it is the first time',
        build: () => WordleBloc(wordsRepository),
        act: (bloc) => bloc.add(WordleGameStarted()),
        expect: () => <WordleState>[
          WordleState(
            wordToGuess: 'random',
            answers: [
              for (var i = 0; i < maxTries; i++)
                WordleAnswer(
                  word: '',
                  results: List.filled(maxWordLength, GuessResult.unknown),
                )
            ],
          ),
        ],
      );

      blocTest<WordleBloc, WordleState>(
        'emits GameStatus.finishedFail and new game '
        'if it has a previous wordToGuess',
        build: () => WordleBloc(wordsRepository),
        seed: () => WordleState(wordToGuess: 'hello'),
        act: (bloc) => bloc.add(WordleGameStarted()),
        expect: () => <WordleState>[
          WordleState(
            wordToGuess: 'hello',
            gameStatus: GameStatus.finishedFail,
          ),
          WordleState(
            wordToGuess: 'random',
            answers: [
              for (var i = 0; i < maxTries; i++)
                WordleAnswer(
                  word: '',
                  results: List.filled(maxWordLength, GuessResult.unknown),
                )
            ],
          ),
        ],
      );
    });

    group('WordleCurrentAnswerUpdated', () {
      blocTest<WordleBloc, WordleState>(
        'emits current answer updated',
        build: () => WordleBloc(wordsRepository),
        act: (bloc) => bloc.add(WordleCurrentAnswerUpdated('newAnswer')),
        expect: () => const <WordleState>[
          WordleState(
            currentAnswer: 'newAnswer',
            gameStatus: GameStatus.playing,
          )
        ],
      );
    });

    group('WordleAnswerSubmitted', () {
      const shortWord = 'aaa';
      const notExistingWord = 'aaaaa';
      const validWord = 'hello';

      blocTest<WordleBloc, WordleState>(
        'emits notEnoughCharacters if current answer is too short '
        'and clean submission status',
        build: () => WordleBloc(wordsRepository),
        seed: () => WordleState(currentAnswer: shortWord),
        act: (bloc) => bloc.add(WordleAnswerSubmitted()),
        expect: () => const <WordleState>[
          WordleState(
            currentAnswer: shortWord,
            submissionStatus: SubmissionStatus.notEnoughCharacters,
          ),
          WordleState(currentAnswer: shortWord)
        ],
      );

      blocTest<WordleBloc, WordleState>(
        'emits wordNotInDictionary if current answer is not in the dictionary',
        setUp: () =>
            when(() => wordsRepository.wordExists(any())).thenReturn(false),
        build: () => WordleBloc(wordsRepository),
        seed: () => WordleState(currentAnswer: notExistingWord),
        act: (bloc) => bloc.add(WordleAnswerSubmitted()),
        expect: () => const <WordleState>[
          WordleState(
            currentAnswer: notExistingWord,
            submissionStatus: SubmissionStatus.wordNotInDictionary,
          ),
          WordleState(currentAnswer: notExistingWord)
        ],
      );

      blocTest<WordleBloc, WordleState>(
        'emits valid if current answer is in the dictionary',
        setUp: () =>
            when(() => wordsRepository.wordExists(any())).thenReturn(true),
        build: () => WordleBloc(wordsRepository),
        seed: () => WordleState(currentAnswer: validWord),
        act: (bloc) => bloc.add(WordleAnswerSubmitted()),
        expect: () => const <WordleState>[
          WordleState(
            currentAnswer: validWord,
            submissionStatus: SubmissionStatus.valid,
          ),
          WordleState(currentAnswer: validWord)
        ],
      );
    });
  });
}
