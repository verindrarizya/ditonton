import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetWatchlistTvSeries(mockTvSeriesRepository);
  });

  test("should get list of tv series from repository", () async {
    when(mockTvSeriesRepository.getWatchlistTvSeries())
        .thenAnswer((_) async => Right(testTvList));

    final result = await useCase.execute();

    verify(mockTvSeriesRepository.getWatchlistTvSeries());
    expect(result, Right(testTvList));
  });
}