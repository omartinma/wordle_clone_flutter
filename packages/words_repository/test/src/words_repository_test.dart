// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:words_repository/words_repository.dart';

class MockWords extends Mock implements List<String> {}

void main() {
  group('WordsRepository', () {
    final words = ['a', 'hello'];
    late WordsRepository wordsRepository;
    setUp(() {
      wordsRepository = WordsRepository(words);
    });

    test('can be instantiated', () {
      expect(WordsRepository(words), isNotNull);
    });

    group('getNextWord', () {
      test('returns if any word', () {
        final nextWord = wordsRepository.getNextWord();
        expect(nextWord, equals('hello'));
      });
    });

    group('wordExists', () {
      test('returns true if word is in the list', () {
        final exists = wordsRepository.wordExists('hello');
        expect(exists, equals(true));
      });

      test('returns false if word is not in the list', () {
        final exists = wordsRepository.wordExists('random');
        expect(exists, equals(false));
      });
    });
  });
}
