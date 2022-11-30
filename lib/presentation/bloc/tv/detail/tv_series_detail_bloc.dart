import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {

  final GetTvSeriesDetail _getTvDetail;

  TvSeriesDetailBloc(this._getTvDetail) : super(TvSeriesDetailEmpty()) {
    on<GetTvDetailEvent>((event, emit) async {
      emit(TvSeriesDetailLoading());

      final result = await _getTvDetail.execute(event.id);

      result.fold(
          (failure) {
            emit(TvSeriesDetailError(failure.message));
          },
          (data) {
            emit(TvSeriesDetailHasData(data));
          }
      );
    });
  }
}
