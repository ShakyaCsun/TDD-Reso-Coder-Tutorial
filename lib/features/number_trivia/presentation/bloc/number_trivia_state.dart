part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoadInProgress extends NumberTriviaState {}

class NumberTriviaLoadSuccess extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoadSuccess({@required this.trivia});

  @override
  List<Object> get props => super.props..addAll([trivia]);
}

class NumberTriviaLoadFailure extends NumberTriviaState {
  final String message;

  NumberTriviaLoadFailure({@required this.message});

  @override
  List<Object> get props => super.props..addAll([message]);
}
