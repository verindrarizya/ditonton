import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class SearchTvSeries {
  final TvSeriesRepository _repository;

  SearchTvSeries(this._repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return _repository.searchTvSeriesList(query);
  }
}