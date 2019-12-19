import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart'

import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
    
  final NumberTriviaRemoteDataSource remote;
  final NumberTriviaLocalDataSource local;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remote,
    @required this.local,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    return null;
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    return null;
  }
}