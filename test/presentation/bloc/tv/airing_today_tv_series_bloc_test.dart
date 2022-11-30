import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_airing_today.dart';
import 'package:ditonton/presentation/bloc/tv/airing_today/airing_today_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'airing_today_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesAiringToday
])
void main() {
  late MockGetTvSeriesAiringToday mockGetTvSeriesAiringToday;
  late AiringTodayTvSeriesBloc airingTodayTvSeriesBloc;

  setUp(() {
    mockGetTvSeriesAiringToday = MockGetTvSeriesAiringToday();
    airingTodayTvSeriesBloc = AiringTodayTvSeriesBloc(mockGetTvSeriesAiringToday);
  });

  test("initial state should be empty", () {
    expect(airingTodayTvSeriesBloc.state, AiringTodayTvSeriesEmpty());
  });

  blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesAiringToday.execute())
          .thenAnswer((_) async => Right(testTvList));
      return airingTodayTvSeriesBloc;
    },
    act: (bloc) => bloc.add(GetAiringTodayTvSeriesEvent()),
    expect: () => <AiringTodayTvSeriesState>[
      AiringTodayTvSeriesLoading(),
      AiringTodayTvSeriesHasData(testTvList)
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesAiringToday.execute());
    }
  );

  blocTest<AiringTodayTvSeriesBloc, AiringTodayTvSeriesState>(
      'should emit [Loading, Error] when data is gotten unsuccessfully',
      build: () {
        when(mockGetTvSeriesAiringToday.execute())
            .thenAnswer((_) async => Left(ServerFailure("Failed")));
        return airingTodayTvSeriesBloc;
      },
      act: (bloc) => bloc.add(GetAiringTodayTvSeriesEvent()),
      expect: () => <AiringTodayTvSeriesState>[
        AiringTodayTvSeriesLoading(),
        AiringTodayTvSeriesError("Failed")
      ],
      verify: (bloc) {
        verify(mockGetTvSeriesAiringToday.execute());
      }
  );
}