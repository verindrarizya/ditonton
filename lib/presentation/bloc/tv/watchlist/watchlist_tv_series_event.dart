part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesEvent extends Equatable {
  const WatchlistTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class GetWatchlistTvSeriesEvent extends WatchlistTvSeriesEvent {}

class GetWatchlistTvSeriesStatus extends WatchlistTvSeriesEvent {
  final int id;

  GetWatchlistTvSeriesStatus(this.id);

  @override
  List<Object> get props => [id];
}

class WatchlistTvSeriesAdd extends WatchlistTvSeriesEvent {
  final TvDetail tvDetail;

  WatchlistTvSeriesAdd(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

class WatchlistTvSeriesRemove extends WatchlistTvSeriesEvent {
  final TvDetail tvDetail;

  WatchlistTvSeriesRemove(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}