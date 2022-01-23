// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wordle/l10n/l10n.dart';
import 'package:words_repository/words_repository.dart';

class MockWordsRepository extends Mock implements WordsRepository {
  @override
  String getNextWord() => '';
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {WordsRepository? wordsRepository}) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: wordsRepository ?? MockWordsRepository(),
            )
          ],
          child: widget,
        ),
      ),
    );
  }
}
