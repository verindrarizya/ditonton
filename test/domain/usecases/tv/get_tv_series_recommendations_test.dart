import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesRecommendations(mockTvSeriesRepository);
  });

  test("should get list of tv series recommendations from the repository", () async {
    final tId = 1;
    final tTvList = <Tv>[];
    when(mockTvSeriesRepository.getTvSeriesRecommendations(tId))
      .thenAnswer((_) async => Right(tTvList));

    final result = await useCase.execute(tId);

    verify(mockTvSeriesRepository.getTvSeriesRecommendations(tId));
    expect(result, Right(tTvList));
  });
}