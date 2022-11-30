part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesEmpty extends WatchlistTvSeriesState {}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvSeriesHasData extends WatchlistTvSeriesState {
  final List<Tv> result;

  WatchlistTvSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class WatchlistTvSeriesIsAdded extends WatchlistTvSeriesState {
  final bool isAdded;

  WatchlistTvSeriesIsAdded(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class WatchlistTvSeriesMessage extends WatchlistTvSeriesState {
  final String message;

  WatchlistTvSeriesMessage(this.message);

  @override
  List<Object> get props => [message];
}