import 'package:clean_architecture_tdd_course/core/error/failures.dart';
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

  group("GetTriviaForConcreteNumber", () {
    final tNumberString = "1";
    final tNumberParse = 1;
    final tNumberTrivia = NumberTriviaModel(number: 1, text: "test trivia");

    void setUpMockInputConverterSuccess() =>
        when(input.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParse));

    void setUpMockInputConverterFailure() =>
        when(input.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

    test(
      "should call the inputConverter to vlaidate and converte the string to an unsigned integer",
      () async {
        // arrane
        setUpMockInputConverterSuccess();
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
        setUpMockInputConverterFailure();
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

    test(
      "should get data from the concrete use case",
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockConcrete(any));
        // assert
        verify(mockConcrete(Params(number: tNumberParse)));
      },
    );

    test(
      "should emit [Loading, Loaded] when data is gotten successfully",
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      "should emit [Loading, Error] when getting data failure",
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );

    test(
      "should emit [Loading, Error] with a proper message for the error when getting data fails",
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockConcrete(any)).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      },
    );
  });

  group("GetTriviaForRandomNumber", () {
    final tNumberTrivia = NumberTriviaModel(number: 1, text: "test trivia");

    test(
      "should get data from the random use case",
      () async {
        // arrange
        when(mockRandom(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
        await untilCalled(mockRandom(any));
        // assert
        verify(mockRandom(any));
      },
    );

    test(
      "should emit [Loading, Loaded] when data is gotten successfully",
      () async {
        // arrange
        when(mockRandom(NoParams())).thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      "should emit [Loading, Error] when getting data failure",
      () async {
        // arrange
        when(mockRandom(any)).thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );

    test(
      "should emit [Loading, Error] with a proper message for the error when getting data fails",
      () async {
        // arrange
        when(mockRandom(any)).thenAnswer((_) async => Left(CacheFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.state, emitsInOrder(expected));
        // act
        bloc.dispatch(GetTriviaForRandomNumber());
      },
    );
  });
}
