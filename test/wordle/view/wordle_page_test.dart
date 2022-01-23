// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordle/wordle/wordle.dart';
import 'package:words_repository/words_repository.dart';
import '../../helpers/helpers.dart';

void main() {
  group('WordlePage', () {
    late WordsRepository wordsRepository;

    setUp(() {
      wordsRepository = MockWordsRepository();
    });

    testWidgets('renders WordleView', (tester) async {
      await tester.pumpWordlePage(wordsRepository: wordsRepository);
      expect(find.byType(WordleView), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpWordlePage({required WordsRepository wordsRepository}) {
    return pumpApp(
      RepositoryProvider.value(
        value: wordsRepository,
        child: WordlePage(),
      ),
    );
  }
}
