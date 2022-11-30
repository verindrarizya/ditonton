import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_airing_today.dart';
import 'package:equatable/equatable.dart';

part 'airing_today_tv_series_event.dart';
part 'airing_today_tv_series_state.dart';

class AiringTodayTvSeriesBloc extends Bloc<AiringTodayTvSeriesEvent, AiringTodayTvSeriesState> {

  final GetTvSeriesAiringToday _getTvSeriesAiringToday;

  AiringTodayTvSeriesBloc(this._getTvSeriesAiringToday) : super(AiringTodayTvSeriesEmpty()) {
    on<AiringTodayTvSeriesEvent>((event, emit) async {
      emit(AiringTodayTvSeriesLoading());

      final result = await _getTvSeriesAiringToday.execute();

      result.fold(
          (failure) {
            emit(AiringTodayTvSeriesError(failure.message));
          },
          (data) {
            emit(AiringTodayTvSeriesHasData(data));
          }
      );
    });
  }
}
