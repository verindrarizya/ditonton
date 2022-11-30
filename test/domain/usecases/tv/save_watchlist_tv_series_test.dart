import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test("should save tv series to the repository", () async {
    when(mockTvSeriesRepository.saveWatchlist(testTvDetail))
      .thenAnswer((_) async => Right("Added to watchlist"));

    final result = await useCase.execute(testTvDetail);

    verify(mockTvSeriesRepository.saveWatchlist(testTvDetail));
    expect(result, Right("Added to watchlist"));
  });
}