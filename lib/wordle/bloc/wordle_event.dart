part of 'wordle_bloc.dart';

@immutable
abstract class WordleEvent extends Equatable {
  const WordleEvent();
}

class WordleFetchRequested extends WordleEvent {
  const WordleFetchRequested();

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
