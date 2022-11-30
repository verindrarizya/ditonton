import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularMovies
])
void main() {

  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  test("initial state should be empty", () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(testMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(GetPopularMoviesEvent()),
    expect: () => <PopularMoviesState>[
      PopularMoviesLoading(),
      PopularMoviesHasData(testMovieList)
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    }
  );

  blocTest<PopularMoviesBloc, PopularMoviesState>(
    'should emit [Loading, Error] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(GetPopularMoviesEvent()),
    expect: () => <PopularMoviesState>[
      PopularMoviesLoading(),
      PopularMoviesError("Server Failure")
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    }
  );
}