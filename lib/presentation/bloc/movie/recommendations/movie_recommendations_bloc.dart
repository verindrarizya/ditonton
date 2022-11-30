
import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationsBloc extends Bloc<MovieRecommendationsEvent, MovieRecommendationsState> {

  final GetMovieRecommendations _getMovieRecommendations;

  MovieRecommendationsBloc(this._getMovieRecommendations) : super(MovieRecommendationsEmpty()) {
    on<GetMovieRecommendationsEvent>((event, emit) async {
      emit(MovieRecommendationsLoading());

      final result = await _getMovieRecommendations.execute(event.id);

      result.fold(
          (failure) {
            emit(MovieRecommendationsError(failure.message));
          },
          (result) {
            emit(MovieRecommendationsHasData(result));
          }
      );
    });
  }
}
