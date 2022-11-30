part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class GetTvDetailEvent extends TvSeriesDetailEvent {
  final int id;

  GetTvDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}
