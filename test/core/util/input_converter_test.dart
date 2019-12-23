import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter input;

  setUp(() {
    input = InputConverter();
  });

  group("stringToUnsignedInteger", () {
    test(
      "should return an integer when the String represents an unsigned integer",
      () async {
        // arrange
        final str = "123";
        // act
        final result = input.stringToUnsignedInteger(str);
        // assert
        expect(result, Right(123));
      },
    );

    test(
      "should return a Failure when the String is not an integer",
      () async {
        //   arrange
        final str = 'abc';
        // act
        final result = input.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      "should return a Failure when the String is a negative integer",
      () async {
        //   arrange
        final str = '-123';
        // act
        final result = input.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
