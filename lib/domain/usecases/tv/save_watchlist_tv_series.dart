import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class SaveWatchlistTvSeries {
  final TvSeriesRepository _repository;

  SaveWatchlistTvSeries(this._repository);

  Future<Either<Failure, String>> execute(TvDetail tvSeries) {
    return _repository.saveWatchlist(tvSeries);
  }
}