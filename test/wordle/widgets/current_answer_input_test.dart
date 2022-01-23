// ignore_for_file: prefer_const_constructors
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
      await tester.pumpCurrentAnswerInput(wordleBloc: wordleBloc);
      await tester.enterText(
        find.byKey(Key('currentAnswerInput_textField')),
        'aaa',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      verify(() => wordleBloc.add(WordleAnswerSubmitted())).called(1);
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
