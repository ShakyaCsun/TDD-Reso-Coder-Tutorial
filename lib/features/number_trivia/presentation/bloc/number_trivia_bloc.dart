import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - You should enter postive number or Zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(NumberTriviaInitial());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);
      print(inputEither);
      yield* inputEither.fold(
        (failure) async* {
          print(failure);
          yield NumberTriviaLoadFailure(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          print('Integer: $integer');
          yield NumberTriviaLoadInProgress();
          final failureOrTrivia = await getConcreteNumberTrivia(
            Params(number: integer),
          );
          print(failureOrTrivia);
          yield* _loadFailiureOrSuccessState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield NumberTriviaLoadInProgress();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      print(failureOrTrivia);
      yield* _loadFailiureOrSuccessState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _loadFailiureOrSuccessState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (failure) => NumberTriviaLoadFailure(
        message: _mapFailureToMessage(failure),
      ),
      (trivia) => NumberTriviaLoadSuccess(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
