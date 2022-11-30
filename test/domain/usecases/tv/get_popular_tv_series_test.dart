import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;
  
  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetPopularTvSeries(mockTvSeriesRepository);
  });
  
  test("should get list of popular tv series from repository", () async {
    final tTvList = <Tv>[];
    when(mockTvSeriesRepository.getPopularTvSeries())
      .thenAnswer((_) async => Right(tTvList));

    final result = await useCase.execute();

    verify(mockTvSeriesRepository.getPopularTvSeries());
    expect(result, Right(tTvList));
  });
}