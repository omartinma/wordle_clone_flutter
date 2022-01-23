part of 'wordle_bloc.dart';

@immutable
class WordleState extends Equatable {
  const WordleState({
    this.wordToGuess = '',
    this.answers = const [],
    this.currentAnswer = '',
    this.currentTry = 0,
  });

  final String wordToGuess;
  final String currentAnswer;
  final List<WordleAnswer> answers;
  final int currentTry;

  @override
  List<Object?> get props => [wordToGuess, answers, currentAnswer, currentTry];

  WordleState copyWith({
    String? wordToGuess,
    String? currentAnswer,
    List<WordleAnswer>? answers,
    int? currentTry,
  }) {
    return WordleState(
      wordToGuess: wordToGuess ?? this.wordToGuess,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      answers: answers ?? this.answers,
      currentTry: currentTry ?? this.currentTry,
    );
  }
}
