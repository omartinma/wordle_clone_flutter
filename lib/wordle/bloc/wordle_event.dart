part of 'wordle_bloc.dart';

@immutable
abstract class WordleEvent extends Equatable {
  const WordleEvent();
}

class WordleGameStarted extends WordleEvent {
  const WordleGameStarted();

  @override
  List<Object> get props => [];
}

class WordleCurrentAnswerUpdated extends WordleEvent {
  const WordleCurrentAnswerUpdated(this.currentAnswer);

  final String currentAnswer;

  @override
  List<Object> get props => [currentAnswer];
}

class WordleAnswerSubmitted extends WordleEvent {
  const WordleAnswerSubmitted();

  @override
  List<Object> get props => [];
}

class WordleValidAnswerSubmitted extends WordleEvent {
  const WordleValidAnswerSubmitted();

  @override
  List<Object> get props => [];
}
