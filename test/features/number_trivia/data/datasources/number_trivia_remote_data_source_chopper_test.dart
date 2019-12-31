import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/remote/number_trivia_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  NumberTriviaRemoteDataSource dataSource;
  NumberTriviaService service;

  setUp(() {
    service = NumberTriviaService.create();
    dataSource = NumberTriviaRemoteDataSourceChopperImpl(
      service: service,
    );
  });

  group("Chopper", () {
    group("getConcreteNumberTrivia", () {
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture("trivia.json")));
      test(
        '''should perform a GET request on a URL with number
      being the endpoint and with application/json header''',
        () async {
          // arrange
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          print("result: ${result.toJson()}");
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
          // act
          final result = await dataSource.getRandomNumberTrivia();
          // assert
          print("result: ${result.toJson()}");
        },
      );
    });
  });
}
