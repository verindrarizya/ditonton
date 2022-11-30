import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTopRatedTvSeries(mockTvSeriesRepository);
  });

  test("should get list of top rated tv series from repository", () async {
    final tTvList = <Tv>[];
    when(mockTvSeriesRepository.getTopRatedTvSeries())
      .thenAnswer((_) async => Right(tTvList));

    final result = await useCase.execute();

    verify(mockTvSeriesRepository.getTopRatedTvSeries());
    expect(result, Right(tTvList));
  });
}