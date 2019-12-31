import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/remote/mobile_data_interceptor.dart';

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

    final converter = JsonSerializableConverter({
      NumberTriviaModel: NumberTriviaModel.fromJsonFactory,
    });

    final client = ChopperClient(
      services: [
        _$NumberTriviaService(),
      ],
      interceptors: [
        HeadersInterceptor(
          {
            "Cache-Control": "no-cache",
            "Content-Type": "application/json",
          },
        ),
        HttpLoggingInterceptor(),
        CurlInterceptor(),
        // MobileDataCostException(),
      ],
      converter: converter,
    );
    return _$NumberTriviaService(client);
  }
}

typedef T JsonFactory<T>(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      return null;
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(List values) =>
      values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity);

    if (entity is Map) return _decodeMap<T>(entity);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    final jsonRes = super.convertResponse(response);

    return jsonRes.replace<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  Request convertRequest(Request request) => super.convertRequest(request);

  // Response convertError<ResultType, Item>(Response response) {
  //   // use [JsonConverter] to decode json
  //   final jsonRes = super.convertError(response);

  //   return jsonRes.replace<ResourceError>(
  //     body: ResourceError.fromJsonFactory(jsonRes.body),
  //   );
  // }
}
