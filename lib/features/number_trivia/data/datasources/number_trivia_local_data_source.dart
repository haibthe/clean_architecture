import 'dart:convert';

import 'package:clean_architecture_tdd_course/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';
import 'package:meta/meta.dart';

const CACHED_NUMBER_TRIVIA_TAG = "CACHED_NUMBER_TRIVIA";

abstract class NumberTriviaLocalDataSource {
  /// Gets the caches [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Sets the caches[NumberTriviaModel]
  ///
  /// Throws [CacheException] if cache data error.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsString = json.encode(triviaToCache.toJson());
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA_TAG,
      jsString,
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA_TAG);
    if (jsString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsString)));
    } else {
      throw CacheException();
    }
  }
}
