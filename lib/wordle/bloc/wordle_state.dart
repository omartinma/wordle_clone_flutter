part of 'wordle_bloc.dart';

@immutable
class WordleState extends Equatable {
  const WordleState({
    this.wordToGuess = '',
    this.answers = const [],
    this.currentAnswer = '',
    this.currentTry = 1,
    this.submissionStatus = SubmissionStatus.unknown,
    this.gameStatus = GameStatus.started,
  });

  final String wordToGuess;
  final String currentAnswer;
  final List<WordleAnswer> answers;
  final int currentTry;
  final SubmissionStatus submissionStatus;
  final GameStatus gameStatus;

  @override
  List<Object?> get props => [
        wordToGuess,
        answers,
        currentAnswer,
        currentTry,
        submissionStatus,
        gameStatus,
      ];

  WordleState copyWith({
    String? wordToGuess,
    String? currentAnswer,
    List<WordleAnswer>? answers,
    int? currentTry,
    SubmissionStatus? submissionStatus,
    GameStatus? gameStatus,
  }) {
    return WordleState(
      wordToGuess: wordToGuess ?? this.wordToGuess,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      answers: answers ?? this.answers,
      currentTry: currentTry ?? this.currentTry,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gameStatus: gameStatus ?? this.gameStatus,
    );
  }
}

enum SubmissionStatus {
  notEnoughCharacters,
  wordNotInDictionary,
  valid,
  unknown
}
enum GameStatus { started, playing, finishedFail, finishedWon }
