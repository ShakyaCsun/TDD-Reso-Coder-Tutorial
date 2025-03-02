import 'package:clean_architecture/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      int integer = int.parse(str);
      if (integer < 0) {
        throw FormatException();
      }
      return Right(integer);
    } catch (e) {
      print('Format Exception Occurred');
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object> get props => [];
}
