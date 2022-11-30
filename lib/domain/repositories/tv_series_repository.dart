import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

abstract class TvSeriesRepository {
  Future<Either<Failure, List<Tv>>> getTvSeriesAiringToday();
  Future<Either<Failure, List<Tv>>> getPopularTvSeries();
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();
  Future<Either<Failure, TvDetail>> getTvSeriesDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvSeriesRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTvSeriesList(String query);

  Future<Either<Failure, String>> saveWatchlist(TvDetail tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries();
}