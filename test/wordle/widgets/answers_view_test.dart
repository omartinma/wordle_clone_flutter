// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wordle/wordle/wordle.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AnswersView', () {
    late WordleBloc wordleBloc;
    final dummyAnswer = WordleAnswer(
      word: '',
      results: List.filled(maxWordLength, GuessResult.unknown),
    );
    final initialAnswers = [for (var i = 0; i < maxTries; i++) dummyAnswer];

    setUp(() {
      wordleBloc = MockWordleBloc();
      when(() => wordleBloc.state).thenReturn(
        WordleState(answers: initialAnswers),
      );
    });

    testWidgets('renders N AnswerTile', (tester) async {
      await tester.pumpAnswersView(wordleBloc: wordleBloc);
      expect(find.byType(AnswerTile), findsWidgets);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpAnswersView({required WordleBloc wordleBloc}) {
    return pumpApp(
      BlocProvider.value(value: wordleBloc, child: AnswersView()),
    );
  }
}
