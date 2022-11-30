
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListMovieStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListMovieStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late WatchlistMovieBloc watchlistMovieBloc;

  final tId = 1;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListMovieStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    watchlistMovieBloc = WatchlistMovieBloc(
      mockGetWatchlistMovies,
      mockGetWatchListMovieStatus,
      mockSaveWatchlistMovie,
      mockRemoveWatchlistMovie
    );
  });

  test('initial state should be empty', () {
    expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMovieEvent()),
    expect: () => <WatchlistMovieState>[
      WatchlistMovieLoading(),
      WatchlistMovieHasData([testWatchlistMovie])
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Left(DatabaseFailure("Database Failure")));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMovieEvent()),
    expect: () => <WatchlistMovieState>[
      WatchlistMovieLoading(),
      WatchlistMovieError("Database Failure")
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should get watchlist status true when movie id is in watchlist',
    build: () {
      when(mockGetWatchListMovieStatus.execute(tId))
        .thenAnswer((_) async => true);
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMovieStatus(tId)),
    expect: () => <WatchlistMovieState>[
      WatchlistMovieIsAdded(true)
    ],
    verify: (bloc) {
      verify(mockGetWatchListMovieStatus.execute(tId));
    }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should get watchlist status false when movie id is not in watchlist',
      build: () {
        when(mockGetWatchListMovieStatus.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistMovieStatus(tId)),
      expect: () => <WatchlistMovieState>[
        WatchlistMovieIsAdded(false)
      ],
      verify: (bloc) {
        verify(mockGetWatchListMovieStatus.execute(tId));
      }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMessage] with successMessage watchlist movie when movie is added',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
        .thenAnswer((_) async => Right("Success Message"));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovieAdd(testMovieDetail)),
    expect: () => <WatchlistMovieState>[
      WatchlistMovieMessage("Success Message")
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovie.execute(testMovieDetail));
    }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMessage] with failure message watchlist movie when movie is failed to added',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
        .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
      return watchlistMovieBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovieAdd(testMovieDetail)),
    expect: () => <WatchlistMovieState>[
      WatchlistMovieMessage("Failed")
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovie.execute(testMovieDetail));
    }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [WatchlistMessage] with successMessage watchlist movie when movie is removed',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right("Success Message"));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemove(testMovieDetail)),
      expect: () => <WatchlistMovieState>[
        WatchlistMovieMessage("Success Message")
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      }
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [WatchlistMessage] with failure message watchlist movie when movie is failed to removed',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieRemove(testMovieDetail)),
      expect: () => <WatchlistMovieState>[
        WatchlistMovieMessage("Failed")
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      }
  );
}