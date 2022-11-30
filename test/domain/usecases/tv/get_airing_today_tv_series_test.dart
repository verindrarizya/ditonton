import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_series_airing_today.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesAiringToday useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = GetTvSeriesAiringToday(mockTvSeriesRepository);
  });

  test("should get list of tv series from the repository", () async {
    final tTvList = <Tv>[];
    when(mockTvSeriesRepository.getTvSeriesAiringToday())
      .thenAnswer((_) async => Right(tTvList));

    final result = await useCase.execute();

    verify(mockTvSeriesRepository.getTvSeriesAiringToday());
    expect(result, Right(tTvList));
  });


}