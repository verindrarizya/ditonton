part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object> get props => [];
}

class GetWatchlistMovieEvent extends WatchlistMovieEvent {}

class GetWatchlistMovieStatus extends WatchlistMovieEvent {
  final int id;

  GetWatchlistMovieStatus(this.id);

  @override
  List<Object> get props => [id];
}

class WatchlistMovieAdd extends WatchlistMovieEvent {
  final MovieDetail movieDetail;

  WatchlistMovieAdd(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class WatchlistMovieRemove extends WatchlistMovieEvent {
  final MovieDetail movieDetail;

  WatchlistMovieRemove(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}
