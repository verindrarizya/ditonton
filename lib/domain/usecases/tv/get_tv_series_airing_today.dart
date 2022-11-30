import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetTvSeriesAiringToday {
  final TvSeriesRepository _repository;

  GetTvSeriesAiringToday(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getTvSeriesAiringToday();
  }
}