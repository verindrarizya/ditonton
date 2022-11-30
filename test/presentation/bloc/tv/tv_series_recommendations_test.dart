import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:ditonton/presentation/bloc/tv/recommendations/tv_series_recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'tv_series_recommendations_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesRecommendations
])
void main() {
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late TvSeriesRecommendationsBloc tvSeriesRecommendationsBloc;
  final tId = 1;

  setUp(() {
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    tvSeriesRecommendationsBloc = TvSeriesRecommendationsBloc(mockGetTvSeriesRecommendations);
  });

  test("initial state should be empty", () {
    expect(tvSeriesRecommendationsBloc.state, TvSeriesRecommendationsEmpty());
  });

  blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTvList));
      return tvSeriesRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetTvSeriesRecommendationsEvent(tId)),
    expect: () => <TvSeriesRecommendationsState>[
      TvSeriesRecommendationsLoading(),
      TvSeriesRecommendationsHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesRecommendations.execute(tId));
    }
  );

  blocTest<TvSeriesRecommendationsBloc, TvSeriesRecommendationsState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return tvSeriesRecommendationsBloc;
      },
      act: (bloc) => bloc.add(GetTvSeriesRecommendationsEvent(tId)),
      expect: () => <TvSeriesRecommendationsState>[
        TvSeriesRecommendationsLoading(),
        TvSeriesRecommendationsError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesRecommendations.execute(tId));
      }
  );
}