import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_tv.dart';
import 'package:ditonton/data/models/tv/tv_table.dart';

abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvTable tvSeries);
  Future<String> removeWatchlist(TvTable tvSeries);
  Future<TvTable?> getTvSeriesById(int id);
  Future<List<TvTable>> getWatchlistTvSeries();
}

class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {

  final DatabaseHelperTv databaseHelperTv;

  TvSeriesLocalDataSourceImpl({required this.databaseHelperTv});

  @override
  Future<TvTable?> getTvSeriesById(int id) async {
    final result = await databaseHelperTv.getTvSeriesById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTvSeries() async {
    final result = await databaseHelperTv.getWatchlistTvSeries();
    return result.map((e) => TvTable.fromMap(e)).toList();
  }

  @override
  Future<String> insertWatchlist(TvTable tvSeries) async {
    try {
      await databaseHelperTv.insertWatchList(tvSeries);
      return "Added to Watchlist";
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(TvTable tvSeries) async {
    try {
      await databaseHelperTv.removeWatchList(tvSeries);
      return "Removed from Watchlist";
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

}