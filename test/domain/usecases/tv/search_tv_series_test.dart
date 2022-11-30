import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries useCase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    useCase = SearchTvSeries(mockTvSeriesRepository);
  });

  final tTvList = <Tv>[];
  final query = "the boys";

  test("should get list of tv series from repository", () async {
    when(mockTvSeriesRepository.searchTvSeriesList(query))
        .thenAnswer((_) async => Right(tTvList));

    final result = await useCase.execute(query);

    verify(mockTvSeriesRepository.searchTvSeriesList(query));
    expect(result, Right(tTvList));
  });
}