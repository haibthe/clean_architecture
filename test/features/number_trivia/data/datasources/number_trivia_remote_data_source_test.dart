import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource dataSource;
  MockHttpClient mock;

  setUp(() {
    mock = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(
      client: mock,
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(mock.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mock.get(any, headers: anyNamed("headers")))
        .thenAnswer((_) async => http.Response(fixture("trivia.json"), 404));
  }

  group("HttpClient", () {
    group("getConcreteNumberTrivia", () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
      test(
        '''should perform a GET request on a URL with number 
      being the endpoint and with application/json header''',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mock.get(
            "http://numbersapi.com/$tNumber",
            headers: {"Content-Type": "application/json"},
          ));
        },
      );
      test(
        "should return NumberTrivia when the response code is 200 (success)",
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getConcreteNumberTrivia;
          // assert
          expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });

    ///
    group("getRandomNumberTrivia", () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
      test(
        '''should perform a GET request on a URL with number
      being the endpoint and with application/json header''',
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource.getRandomNumberTrivia();
          // assert
          verify(mock.get(
            "http://numbersapi.com/random",
            headers: {"Content-Type": "application/json"},
          ));
        },
      );
      test(
        "should return NumberTrivia when the response code is 200 (success)",
        () async {
          // arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getRandomNumberTrivia();
          // assert
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        "should throw a ServerException when the response code is 404 or other",
        () async {
          // arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getRandomNumberTrivia;
          // assert
          expect(() => call(), throwsA(TypeMatcher<ServerException>()));
        },
      );
    });
  });
}
