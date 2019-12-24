import 'package:clean_architecture_tdd_course/core/util/input_converter.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockConcrete;
  MockGetRandomNumberTrivia mockRandom;
  MockInputConverter input;

  setUp(() {
    mockConcrete = MockGetConcreteNumberTrivia();
    mockRandom = MockGetRandomNumberTrivia();
    input = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockConcrete,
      random: mockRandom,
      inputConverter: input,
    );
  });

  test(
    "initialState should be Empty",
    () async {
      // arrange
      // act
      // asserts
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group("GetConcreteForConcreteNumber", () {
    final tNumberString = "1";
    final tNumberParse = 1;
    final tNumberTrivia = NumberTriviaModel(number: 1, text: "test trivia");

    test(
      "should call the inputConverter to vlaidate and converte the string to an unsigned integer",
      () async {
        // arrane
        when(input.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParse));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(input.stringToUnsignedInteger(any));
        // assert
        verify(input.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      "should emit [Error] when the input is invalid",
      () async {
        // arrange
        when(input.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        // assert
        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
      },
    );
  });
}
