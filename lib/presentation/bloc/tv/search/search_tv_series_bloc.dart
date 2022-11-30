
import 'package:bloc/bloc.dart';
import 'package:ditonton/common/debouncer.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'search_tv_series_event.dart';
part 'search_tv_series_state.dart';

class SearchTvSeriesBloc extends Bloc<SearchTvSeriesEvent, SearchTvSeriesState> {

  final SearchTvSeries _searchTvSeries;

  SearchTvSeriesBloc(this._searchTvSeries) : super(SearchTvSeriesEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTvSeriesLoading());

      final result = await _searchTvSeries.execute(query);

      result.fold(
          (failure) {
            emit(SearchTvSeriesError(failure.message));
          },
          (data) {
            emit(SearchTvSeriesHasData(data));
          }
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
