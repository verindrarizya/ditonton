import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesRecommendations {
  final TvSeriesRepository _repository;

  GetTvSeriesRecommendations(this._repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return _repository.getTvSeriesRecommendations(id);
  }
}