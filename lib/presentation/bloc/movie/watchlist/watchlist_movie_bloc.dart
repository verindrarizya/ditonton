
import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {

  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchListMovieStatus _getWatchListMovieStatus;
  final SaveWatchlistMovie _saveWatchlistMovie;
  final RemoveWatchlistMovie _removeWatchlistMovie;

  WatchlistMovieBloc(
      this._getWatchlistMovies,
      this._getWatchListMovieStatus,
      this._saveWatchlistMovie,
      this._removeWatchlistMovie
      ) : super(WatchlistMovieEmpty()) {
    on<GetWatchlistMovieEvent>((event, emit) async{
      emit(WatchlistMovieLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
          (failure) {
            emit(WatchlistMovieError(failure.message));
          },
          (data) {
            emit(WatchlistMovieHasData(data));
          }
      );
    });

    on<GetWatchlistMovieStatus>((event, emit) async {
      final result = await _getWatchListMovieStatus.execute(event.id);
      emit(WatchlistMovieIsAdded(result));
    });

    on<WatchlistMovieAdd>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _saveWatchlistMovie.execute(movieDetail);

      result.fold(
          (failure) {
            emit(WatchlistMovieMessage(failure.message));
          },
          (successMessage) {
            emit(WatchlistMovieMessage(successMessage));
          }
      );
    });

    on<WatchlistMovieRemove>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await _removeWatchlistMovie.execute(movieDetail);

      result.fold(
          (failure) {
            emit(WatchlistMovieMessage(failure.message));
          },
          (successMessage) {
            emit(WatchlistMovieMessage(successMessage));
          }
      );
    });
  }
}
