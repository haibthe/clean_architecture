import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;
  MockDataConnectionChecker checker;

  setUp(() {
    checker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(checker);
  });

  group("isConnected", () {
    test(
      "should forward the call to DataConnectionChecker.hasConnection",
      () async {
        // arrange
        final tHasConnectionFuture = Future.value(true);

        when(checker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
        // act
        final result = networkInfo.isConnected;
        // assert
        verify(checker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
