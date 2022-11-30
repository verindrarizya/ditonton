
import 'package:bloc/bloc.dart';
import 'package:ditonton/common/debouncer.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:equatable/equatable.dart';

part 'search_movies_event.dart';
part 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final SearchMovies _searchMovies;

  SearchMoviesBloc(this._searchMovies) : super(SearchMoviesEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchMoviesLoading());

      final result = await _searchMovies.execute(query);

      result.fold(
          (failure) {
            emit(SearchMoviesError(failure.message));
          },
          (data) {
            emit(SearchMoviesHasData(data));
          }
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
