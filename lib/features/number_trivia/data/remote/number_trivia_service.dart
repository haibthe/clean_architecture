import 'package:chopper/chopper.dart';
import 'package:chopper/chopper.dart' as prefix0;
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';

part 'number_trivia_service.chopper.dart';

@ChopperApi(baseUrl: "http://numbersapi.com")
abstract class NumberTriviaService extends ChopperService {
  @Get(
    path: "/{number}",
  )
  Future<Response<NumberTriviaModel>> getConcreteNumberTrivia(
      @Path("number") int number);

  @Get(
    path: "/random",
  )
  Future<Response<NumberTriviaModel>> getRandomNumberTrivia();

  @Post(
    path: "/",
  )
  Future<Response> testPost(
    @Body() Map<String, dynamic> body,
  );

  static NumberTriviaService create() {
    final client = ChopperClient(
      services: [
        _$NumberTriviaService(),
      ],      
      converter: JsonConverter(),
    );
    return _$NumberTriviaService(client);
  }
}
