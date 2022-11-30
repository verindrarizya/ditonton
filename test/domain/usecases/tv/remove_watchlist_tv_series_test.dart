import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = RemoveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test("should verify remove watchlist from repository is called", () async {
    when(mockTvSeriesRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => Right("Removed from watchlist"));

    await useCase.execute(testTvDetail);

    verify(mockTvSeriesRepository.removeWatchlist(testTvDetail));
  });
}