// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wordle/wordle/wordle.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CurrentAnswerInput', () {
    late WordleBloc wordleBloc;

    setUp(() {
      wordleBloc = MockWordleBloc();
      when(() => wordleBloc.state)
          .thenReturn(WordleState(gameStatus: GameStatus.playing));
    });

    testWidgets('adds WordleCurrentAnswerUpdated when writing', (tester) async {
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      await tester.enterText(
        find.byKey(Key('currentAnswerInput_textField')),
        'aaa',
      );
      verify(() => wordleBloc.add(WordleCurrentAnswerUpdated('aaa'))).called(1);
    });

    testWidgets('adds WordleAnswerSubmitted when done input', (tester) async {
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      await tester.enterText(
        find.byKey(Key('currentAnswerInput_textField')),
        'aaa',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      verify(() => wordleBloc.add(WordleAnswerSubmitted())).called(1);
    });

    testWidgets('clears when GameStatus.started', (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(gameStatus: GameStatus.playing),
          WordleState(),
        ]),
      );
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      expect(
        find.byWidgetPredicate(
          (Widget textField) {
            return textField is TextField && textField.controller?.text == '';
          },
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds WordleValidAnswerSubmitted when SubmissionStatus.valid',
        (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(),
          WordleState(submissionStatus: SubmissionStatus.valid),
        ]),
      );
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      verify(() => wordleBloc.add(WordleValidAnswerSubmitted())).called(1);
    });

    testWidgets(
        'shows not enough characters snack bar if '
        'SubmissionStatus.notEnoughCharacters', (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(),
          WordleState(submissionStatus: SubmissionStatus.notEnoughCharacters),
        ]),
      );
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      await tester.pumpAndSettle();
      expect(find.text('Not enough characers'), findsOneWidget);
    });

    testWidgets(
        'shows not enough characters snack bar if '
        'SubmissionStatus.wordNotInDictionary', (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(),
          WordleState(submissionStatus: SubmissionStatus.wordNotInDictionary),
        ]),
      );
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      await tester.pumpAndSettle();
      expect(find.text('Word not in dictionary'), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpCurrentAnswerInput({required WordleBloc wordleBloc}) {
    return pumpApp(
      BlocProvider.value(
        value: wordleBloc,
        child: Scaffold(body: CurrentAnswerInput()),
      ),
    );
  }
}
