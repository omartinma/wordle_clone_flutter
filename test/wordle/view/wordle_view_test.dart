// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wordle/wordle/wordle.dart';

import '../../helpers/pump_app.dart';

class MockWordleBloc extends MockBloc<WordleEvent, WordleState>
    implements WordleBloc {}

void main() {
  group('WordleView', () {
    late WordleBloc wordleBloc;

    setUp(() {
      wordleBloc = MockWordleBloc();
      when(() => wordleBloc.state).thenReturn(WordleState());
    });

    testWidgets('shows failed game snackbar if GameStatus.finishedFail',
        (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(gameStatus: GameStatus.finishedFail)
        ]),
      );

      await tester.pumpWordleView(wordleBloc: wordleBloc);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('wordleView_failedGame_snackBar')), findsOneWidget);
    });

    testWidgets('shows won game snackbar if GameStatus.finishedWon',
        (tester) async {
      whenListen(
        wordleBloc,
        Stream.fromIterable(const <WordleState>[
          WordleState(gameStatus: GameStatus.finishedWon)
        ]),
      );

      await tester.pumpWordleView(wordleBloc: wordleBloc);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('wordleView_wonGame_snackBar')), findsOneWidget);
    });

    testWidgets('adds WordleGameStarted after click in refresh button',
        (tester) async {
      await tester.pumpWordleView(wordleBloc: wordleBloc);
      await tester.tap(find.byType(RefreshButton));
      verify(() => wordleBloc.add(WordleGameStarted())).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpWordleView({required WordleBloc wordleBloc}) {
    return pumpApp(
      BlocProvider.value(value: wordleBloc, child: WordleView()),
    );
  }
}
