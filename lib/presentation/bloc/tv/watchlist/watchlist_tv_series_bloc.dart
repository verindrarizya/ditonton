import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {

  final GetWatchlistTvSeries _getWatchlistTvSeries;
  final GetWatchListTvSeriesStatus _getWatchlistTvSeriesStatus;
  final SaveWatchlistTvSeries _saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries _removeWatchlistTvSeries;

  WatchlistTvSeriesBloc(
      this._getWatchlistTvSeries,
      this._getWatchlistTvSeriesStatus,
      this._saveWatchlistTvSeries,
      this._removeWatchlistTvSeries
      ) : super(WatchlistTvSeriesEmpty()) {

    on<GetWatchlistTvSeriesEvent>((event, emit) async {
      emit(WatchlistTvSeriesLoading());

      final result = await _getWatchlistTvSeries.execute();

      result.fold(
          (failure) {
            emit(WatchlistTvSeriesError(failure.message));
          },
          (data) {
            emit(WatchlistTvSeriesHasData(data));
          }
      );
    });

    on<GetWatchlistTvSeriesStatus>((event, emit) async {
      final result = await _getWatchlistTvSeriesStatus.execute(event.id);
      emit(WatchlistTvSeriesIsAdded(result));
    });

    on<WatchlistTvSeriesAdd>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await _saveWatchlistTvSeries.execute(tvDetail);

      result.fold(
          (failure) {
            emit(WatchlistTvSeriesMessage(failure.message));
          },
          (successMessage) {
            emit(WatchlistTvSeriesMessage(successMessage));
          }
      );
    });

    on<WatchlistTvSeriesRemove>((event, emit) async {
      final tvDetail = event.tvDetail;
      final result = await _removeWatchlistTvSeries.execute(tvDetail);

      result.fold(
          (failure) {
            emit(WatchlistTvSeriesMessage(failure.message));
          },
          (successMessage) {
            emit(WatchlistTvSeriesMessage(successMessage));
          }
      );
    });

  }
}
