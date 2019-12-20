import '../models/number_trivia_model.dart';

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
