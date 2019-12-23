import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource dataSource;
  MockSharedPreferences mock;

  setUp(() {
    mock = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mock,
    );
  });

  group("getLastNumberTrivia", () {
    final cachedStr = fixture("trivia_cached.json");
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(cachedStr));

    test(
      "should return NumberTrivia from SharedPreferences when there is one in the cache",
      () async {
        // arrange
        when(mock.getString(any)).thenReturn(cachedStr);
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mock.getString(CACHED_NUMBER_TRIVIA_TAG));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      "should throw a CacheException when there is not a cached value",
      () async {
        // arrange
        when(mock.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group("cacheNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test trivia");    
    test(
      "should call SharedPreferences to cache the data",
      () async {
        // arrange

        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(
            mock.setString(CACHED_NUMBER_TRIVIA_TAG, expectedJsonString));
      },
    );
  });
}
