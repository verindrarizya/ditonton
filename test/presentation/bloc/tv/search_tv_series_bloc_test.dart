
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/search/search_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'search_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  SearchTvSeries
])
void main() {
  late MockSearchTvSeries mockSearchTvSeries;
  late SearchTvSeriesBloc searchTvSeriesBloc;

  final tQuery = "name";

  setUp(() {
    mockSearchTvSeries = MockSearchTvSeries();
    searchTvSeriesBloc = SearchTvSeriesBloc(mockSearchTvSeries);
  });

  test("initial state should be empty", () {
    expect(searchTvSeriesBloc.state, SearchTvSeriesEmpty());
  });

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTvSeries.execute(tQuery))
        .thenAnswer((_) async => Right(testTvList));
      return searchTvSeriesBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => <SearchTvSeriesState>[
      SearchTvSeriesLoading(),
      SearchTvSeriesHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockSearchTvSeries.execute(tQuery));
    }
  );

  blocTest<SearchTvSeriesBloc, SearchTvSeriesState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockSearchTvSeries.execute(tQuery))
            .thenAnswer((_) async => Left(ServerFailure("Server Failure")));
        return searchTvSeriesBloc;
      },
      act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => <SearchTvSeriesState>[
        SearchTvSeriesLoading(),
        SearchTvSeriesError("Server Failure")
      ],
      verify: (bloc) {
        verify(mockSearchTvSeries.execute(tQuery));
      }
  );
}