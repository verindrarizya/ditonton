import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesDetail useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesDetail(mockTvSeriesRepository);
  });

  test("should get tv series detail from the repository", () async {
    final tId = 1;
    when(mockTvSeriesRepository.getTvSeriesDetail(tId))
      .thenAnswer((_) async => Right(testTvDetail));

    final result = await useCase.execute(tId);

    verify(mockTvSeriesRepository.getTvSeriesDetail(tId));
    expect(result, Right(testTvDetail));
  });
}