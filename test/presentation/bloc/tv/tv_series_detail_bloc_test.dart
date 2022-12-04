import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv/detail/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail
])
void main() {
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  final tId = 1;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    tvSeriesDetailBloc = TvSeriesDetailBloc(mockGetTvSeriesDetail);
  });

  test('initial state should be empty', () {
    expect(tvSeriesDetailBloc.state, TvSeriesDetailEmpty());
  });

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvDetail));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(GetTvDetailEvent(tId)),
    expect: () => <TvSeriesDetailState>[
      TvSeriesDetailLoading(),
      TvSeriesDetailHasData(testTvDetail)
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
    }
  );

  blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
    'should emit [Loading, Error] when data is gotten unsuccessfully',
    build: () {
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure("Failed")));
      return tvSeriesDetailBloc;
    },
    act: (bloc) => bloc.add(GetTvDetailEvent(tId)),
    expect: () => <TvSeriesDetailState>[
      TvSeriesDetailLoading(),
      TvSeriesDetailError("Failed")
    ],
    verify: (bloc) {
      verify(mockGetTvSeriesDetail.execute(tId));
    }
  );
}