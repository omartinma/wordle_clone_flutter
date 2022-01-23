// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wordle/app/app.dart';
import 'package:words_repository/words_repository.dart';
import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    late WordsRepository wordsRepository;

    setUp(() {
      wordsRepository = MockWordsRepository();
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpApp(
        App(wordsRepository: wordsRepository),
      );
      expect(find.byType(AppView), findsOneWidget);
    });
  });
}
