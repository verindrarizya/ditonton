part of 'tv_series_recommendations_bloc.dart';

abstract class TvSeriesRecommendationsState extends Equatable {
  const TvSeriesRecommendationsState();

  @override
  List<Object> get props => [];
}

class TvSeriesRecommendationsEmpty extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsLoading extends TvSeriesRecommendationsState {}

class TvSeriesRecommendationsError extends TvSeriesRecommendationsState {
  final String message;

  TvSeriesRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesRecommendationsHasData extends TvSeriesRecommendationsState {
  final List<Tv> result;

  TvSeriesRecommendationsHasData(this.result);

  @override
  List<Object> get props => [result];
}
