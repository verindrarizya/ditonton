import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/top_rated/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTopRatedTvSeries
])
void main() {
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
  });

  test("initial state should be empty", () {
    expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesEmpty());
  });

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedTvSeriesEvent()),
    expect: () => <TopRatedTvSeriesState>[
      TopRatedTvSeriesLoading(),
      TopRatedTvSeriesHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvSeries.execute());
    }
  );

  blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetTopRatedTvSeriesEvent()),
      expect: () => <TopRatedTvSeriesState>[
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvSeries.execute());
      }
  );
}