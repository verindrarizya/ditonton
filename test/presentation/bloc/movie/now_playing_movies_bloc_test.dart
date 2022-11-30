import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing/now_playing_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies
])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  test("initial state should be empty", () {
    expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlayingMoviesEvent()),
    expect: () => <NowPlayingMoviesState>[
      NowPlayingMoviesLoading(),
      NowPlayingMoviesHasData(testMovieList)
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    }
  );

  blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
      return nowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlayingMoviesEvent()),
    expect: () => <NowPlayingMoviesState>[
      NowPlayingMoviesLoading(),
      NowPlayingMoviesError("Server Failure")
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
    }
  );
}