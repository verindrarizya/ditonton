import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/popular/popular_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetPopularTvSeries
])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularTvSeriesBloc popularTvSeriesBloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
  });

  test("initial state should be empty", () {
    expect(popularTvSeriesBloc.state, PopularTvSeriesEmpty());
  });

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten succesfully',
    build: () {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(testTvList));
      return popularTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetPopularTvSeriesEvent()),
    expect: () => <PopularTvSeriesState>[
      PopularTvSeriesLoading(),
      PopularTvSeriesHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockGetPopularTvSeries.execute());
    }
  );

  blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetPopularTvSeriesEvent()),
      expect: () => <PopularTvSeriesState>[
        PopularTvSeriesLoading(),
        PopularTvSeriesError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetPopularTvSeries.execute());
      }
  );
}