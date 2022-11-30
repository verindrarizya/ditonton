import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_object_tv.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelperTv mockDatabaseHelperTv;
  
  setUp(() {
    mockDatabaseHelperTv = MockDatabaseHelperTv();
    dataSource = TvSeriesLocalDataSourceImpl(databaseHelperTv: mockDatabaseHelperTv);
  });
  
  group("save tv series watchlist", () {
    test("should return success message when insert to database is success", () async {
      when(mockDatabaseHelperTv.insertWatchList(testTvTable)).thenAnswer((_) async => 1);
      
      final result = await dataSource.insertWatchlist(testTvTable);
      
      expect(result, "Added to Watchlist");
    });

    test("should throw DatabaseException when insert to database is failed", () async {
      when(mockDatabaseHelperTv.insertWatchList(testTvTable)).thenThrow(Exception());

      final call = dataSource.insertWatchlist(testTvTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });
  
  group("remove tv series watchlist", () {
    test("should return success message when remove from database is success", () async {
      when(mockDatabaseHelperTv.removeWatchList(testTvTable)).thenAnswer((_) async => 1);

      final result = await dataSource.removeWatchlist(testTvTable);

      expect(result, "Removed from Watchlist");
    });

    test("should throw DatabaseException when remove from database is failed", () async {
      when(mockDatabaseHelperTv.removeWatchList(testTvTable)).thenThrow(Exception());

      final call = dataSource.removeWatchlist(testTvTable);

      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group("get tv series detail by id", () {
    final tId = 1;

    test("should return tv series detail table when data is found", () async {
      when(mockDatabaseHelperTv.getTvSeriesById(tId)).thenAnswer((_) async => testTvMap);

      final result = await dataSource.getTvSeriesById(tId);

      expect(result, testTvTable);
    });

    test("should return null when data is not found", () async {
      when(mockDatabaseHelperTv.getTvSeriesById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getTvSeriesById(tId);

      expect(result, null);
    });
  });

  group("get watchlist tv series ", () {
    test("should return list of TvTable from database", () async {
      when(mockDatabaseHelperTv.getWatchlistTvSeries()).thenAnswer((_) async => [testTvMap]);

      final result = await dataSource.getWatchlistTvSeries();

      expect(result, [testTvTable]);
    });
  });
}