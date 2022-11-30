import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([
  SearchMovies
])
void main() {

  late MockSearchMovies mockSearchMovies;
  late SearchMoviesBloc searchMoviesBloc;

  final tQuery = "spiderman";

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMoviesBloc = SearchMoviesBloc(mockSearchMovies);
  });

  test('initial state should be empty', () {
    expect(searchMoviesBloc.state, SearchMoviesEmpty());
  });

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
        .thenAnswer((_) async => Right(testMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => <SearchMoviesState>[
      SearchMoviesLoading(),
      SearchMoviesHasData(testMovieList)
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    }
  );
  
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies.execute(tQuery))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    expect: () => <SearchMoviesState>[
      SearchMoviesLoading(),
      SearchMoviesError('Server Failure')
    ],
    verify: (bloc) {
      verify(mockSearchMovies.execute(tQuery));
    },
    wait: const Duration(milliseconds: 500)
  );
}