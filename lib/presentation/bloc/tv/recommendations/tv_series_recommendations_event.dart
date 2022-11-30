part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsEvent extends Equatable {
  const TvSeriesRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class GetTvSeriesRecommendationsEvent extends TvSeriesRecommendationsEvent {
  final int id;

  GetTvSeriesRecommendationsEvent(this.id);

  @override
  List<Object> get props => [id];
}
