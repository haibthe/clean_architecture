// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_trivia_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$NumberTriviaService extends NumberTriviaService {
  _$NumberTriviaService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = NumberTriviaService;

  Future<Response<NumberTriviaModel>> getConcreteNumberTrivia(int number) {
    final $url = 'http://numbersapi.com/${number}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<NumberTriviaModel, NumberTriviaModel>($request);
  }

  Future<Response<NumberTriviaModel>> getRandomNumberTrivia() {
    final $url = 'http://numbersapi.com/random';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<NumberTriviaModel, NumberTriviaModel>($request);
  }

  Future<Response<dynamic>> testPost(Map<String, dynamic> body) {
    final $url = 'http://numbersapi.com/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
