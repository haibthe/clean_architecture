import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/remote/number_trivia_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  NumberTriviaService service;

  setUp(() {
    service = NumberTriviaService.create();
  });

  test(
    "service chopper",
    () async {
      // act
      final result = await service.getConcreteNumberTrivia(1);
      print("result: ${result.body.toJson()}");

      final random = await service.getRandomNumberTrivia();
      print("result: ${random.body.toJson()}");
    },
  );
}
