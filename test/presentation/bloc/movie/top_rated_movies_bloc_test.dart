
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetTopRatedMovies
])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test("initial state should be empty", () {
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedMoviesEvent()),
    expect: () => <TopRatedMoviesState>[
      TopRatedMoviesLoading(),
      TopRatedMoviesHasData(testMovieList)
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    }
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedMoviesEvent()),
    expect: () => <TopRatedMoviesState>[
      TopRatedMoviesLoading(),
      TopRatedMoviesError("Server Failure")
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    }
  );
}