
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTvSeries,
  GetWatchListTvSeriesStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries
])
void main() {

  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;
  late MockGetWatchListTvSeriesStatus mockGetWatchListTvSeriesStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;

  final tId = 1;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    mockGetWatchListTvSeriesStatus = MockGetWatchListTvSeriesStatus();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(
      mockGetWatchlistTvSeries,
      mockGetWatchListTvSeriesStatus,
      mockSaveWatchlistTvSeries,
      mockRemoveWatchlistTvSeries
    );
  });

  test("inital state should be empty", () async {
    expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
        .thenAnswer((_) async => Right(testTvList));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTvSeriesEvent()),
    expect: () => <WatchlistTvSeriesState>[
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetWatchlistTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure("Failed")));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTvSeriesEvent()),
    expect: () => <WatchlistTvSeriesState>[
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesError("Failed")
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTvSeries.execute());
    }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should get watchlist status true when tv series id is in watchlist',
    build: () {
      when(mockGetWatchListTvSeriesStatus.execute(tId))
        .thenAnswer((_) async => true);
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTvSeriesStatus(tId)),
    expect: () => <WatchlistTvSeriesState>[
      WatchlistTvSeriesIsAdded(true)
    ],
    verify: (bloc) {
      verify(mockGetWatchListTvSeriesStatus.execute(tId));
    }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should get watchlist status false when tv series id is not in watchlist',
      build: () {
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetWatchlistTvSeriesStatus(tId)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesIsAdded(false)
      ],
      verify: (bloc) {
        verify(mockGetWatchListTvSeriesStatus.execute(tId));
      }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [WatchlistMessage] with successMessage when tv series is added',
    build: () {
      when(mockSaveWatchlistTvSeries.execute(testTvDetail))
        .thenAnswer((_) async => Right("Success Message"));
      return watchlistTvSeriesBloc;
    },
    act: (bloc) => bloc.add(WatchlistTvSeriesAdd(testTvDetail)),
    expect: () => <WatchlistTvSeriesState>[
      WatchlistTvSeriesMessage("Success Message")
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTvSeries.execute(testTvDetail));
    }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistMessage] with failureMessage when tv series is failed to added',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesAdd(testTvDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesMessage("Failed")
      ],
      verify: (bloc) {
        verify(mockSaveWatchlistTvSeries.execute(testTvDetail));
      }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistMessage] with successMessage when tv series is removed',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvDetail))
            .thenAnswer((_) async => Right("Success Message"));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesRemove(testTvDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesMessage("Success Message")
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvDetail));
      }
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'should emit [WatchlistMessage] with failureMessage when tv series is failed to removed',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvSeriesRemove(testTvDetail)),
      expect: () => <WatchlistTvSeriesState>[
        WatchlistTvSeriesMessage("Failed")
      ],
      verify: (bloc) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvDetail));
      }
  );

}