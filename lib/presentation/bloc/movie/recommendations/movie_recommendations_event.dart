part of 'movie_recommendations_bloc.dart';

abstract class MovieRecommendationsEvent extends Equatable {
  const MovieRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class GetMovieRecommendationsEvent extends MovieRecommendationsEvent {
  final int id;

  GetMovieRecommendationsEvent(this.id);

  @override
  List<Object> get props => [id];
}
