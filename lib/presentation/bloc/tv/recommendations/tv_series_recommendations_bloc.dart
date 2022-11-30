import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_recommendations_event.dart';
part 'tv_series_recommendations_state.dart';

class TvSeriesRecommendationsBloc extends Bloc<TvSeriesRecommendationsEvent, TvSeriesRecommendationsState> {

  final GetTvSeriesRecommendations _getTvSeriesRecommendations;

  TvSeriesRecommendationsBloc(this._getTvSeriesRecommendations) : super(TvSeriesRecommendationsEmpty()) {
    on<GetTvSeriesRecommendationsEvent>((event, emit) async {
      emit(TvSeriesRecommendationsLoading());

      final result = await _getTvSeriesRecommendations.execute(event.id);

      result.fold(
          (failure) {
            emit(TvSeriesRecommendationsError(failure.message));
          },
          (data) {
            emit(TvSeriesRecommendationsHasData(data));
          }
      );
    });
  }
}
