import 'package:ditonton/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvSeriesStatus useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetWatchListTvSeriesStatus(mockTvSeriesRepository);
  });

  test("should get tv series watchlist status from repository", () async {
    final tId = 1;
    when(mockTvSeriesRepository.isAddedToWatchlist(tId))
      .thenAnswer((_) async => true);

    final result = await useCase.execute(tId);

    verify(mockTvSeriesRepository.isAddedToWatchlist(tId));
    expect(result, true);
  });
}