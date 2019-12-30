import 'package:chopper/chopper.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/remote/number_trivia_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NumberTriviaService service;

  setUp(() {
    service = NumberTriviaService.create();
  });

  test(
    "Service chopper",
    () async {
      NumberTriviaModel tNumber = NumberTriviaModel(number: 1, text: "Test");

      // act
      final result = await service.getConcreteNumberTrivia(1);
      expect(tNumber, result.body);
    },
  );
}
