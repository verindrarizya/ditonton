import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv/tv_detail_response.dart';
import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_object_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesLocalDataSource mockLocalDataSource;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    repository = TvSeriesRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource
    );
  });

  final tTvModel = TvModel(
    backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
    firstAirDate:"2008-01-20",
    genreIds: [18],
    id: 1396,
    name: "Breaking Bad",
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Breaking Bad",
    overview: "Breaking Bad overview",
    popularity: 501.562,
    posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
    voteAverage: 8.8,
    voteCount: 10332
  );

  final tTv = Tv(
      backdropPath: "/84XPpjGvxNyExjSuLQe0SzioErt.jpg",
      firstAirDate:"2008-01-20",
      genreIds: [18],
      id: 1396,
      name: "Breaking Bad",
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Breaking Bad",
      overview: "Breaking Bad overview",
      popularity: 501.562,
      posterPath: "/ggFHVNu6YYI5L9pCfOacjizRGt.jpg",
      voteAverage: 8.8,
      voteCount: 10332
  );

  final tId = 1;
  final tTvResponse = TvDetailResponse(
      lastAirDate: "lastAirDate",
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      status: "status",
      tagline: "tagline",
      type: "type",
      voteCount: 1,
      voteAverage: 1.0,
      posterPath: "posterPath",
      popularity: 1.0,
      overview: "overview",
      originalName: "originalName",
      originalLanguage: "originalLanguage",
      name: "name",
      id: 1,
      genres: [GenreModel(id: 1, name: "genre 1")],
      firstAirDate: "firstAirDate",
      backdropPath: "backdropPath"
  );

  final tTvModelList = [tTvModel];
  final tTvList = [tTv];

  group("airing today tv series", () {
    test("should return remote data when the call to remote data source is successful", () async {
      when(mockRemoteDataSource.getTvSeriesAiringToday()).thenAnswer((_) async => tTvModelList);

      final result = await repository.getTvSeriesAiringToday();

      verify(mockRemoteDataSource.getTvSeriesAiringToday());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test("should return server failure when the call to remote data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTvSeriesAiringToday()).thenThrow(ServerException());

      final result = await repository.getTvSeriesAiringToday();

      verify(mockRemoteDataSource.getTvSeriesAiringToday());
      expect(result, Left(ServerFailure("")));
    });

    test("should return connection failure when the device is not connected to internet", () async {
      when(mockRemoteDataSource.getTvSeriesAiringToday()).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.getTvSeriesAiringToday();

      verify(mockRemoteDataSource.getTvSeriesAiringToday());
      expect(result, Left(ConnectionFailure("Failed to connect to the network")));
    });
  });

  group("popular tv series", () {
    test("should return tv series list when call to data source is success", () async {
      when(mockRemoteDataSource.getPopularTvSeries()).thenAnswer((_) async => tTvModelList);

      final result = await repository.getPopularTvSeries();

      verify(mockRemoteDataSource.getPopularTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test("should return server failure when call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getPopularTvSeries()).thenThrow(ServerException());

      final result = await repository.getPopularTvSeries();

      verify(mockRemoteDataSource.getPopularTvSeries());
      expect(result, Left(ServerFailure("")));
    });

    test("should return connection failure when device is not connected to the internet", () async {
      when(mockRemoteDataSource.getPopularTvSeries()).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.getPopularTvSeries();

      verify(mockRemoteDataSource.getPopularTvSeries());
      expect(result, Left(ConnectionFailure("Failed to connect to the network")));
    });
  });

  group("top rated tv series", () {
    test("should return tv series list when call to data source is successful", () async {
      when(mockRemoteDataSource.getTopRatedTvSeries()).thenAnswer((_) async => tTvModelList);

      final result = await repository.getTopRatedTvSeries();

      verify(mockRemoteDataSource.getTopRatedTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test("should return server failure when call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTopRatedTvSeries()).thenThrow(ServerException());

      final result = await repository.getTopRatedTvSeries();

      verify(mockRemoteDataSource.getTopRatedTvSeries());
      expect(result, Left(ServerFailure("")));
    });

    test("should return connection failure when call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTopRatedTvSeries()).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.getTopRatedTvSeries();

      verify(mockRemoteDataSource.getTopRatedTvSeries());
      expect(result, Left(ConnectionFailure("Failed to connect to the network")));
    });
  });

  group("get tv series detail", () {
    test("should return tv detail data when the call is successful", () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId)).thenAnswer((_) async => tTvResponse);

      final result = await repository.getTvSeriesDetail(tId);

      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, Right(testTvDetail));
    });

    test("should return server failure when the call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId)).thenThrow(ServerException());

      final result = await repository.getTvSeriesDetail(tId);

      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure(""))));
    });

    test("should return connection failure when the call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId)).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.getTvSeriesDetail(tId);

      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, Left(ConnectionFailure("Failed to connect to the network")));
    });
  });

  group("get tv series recommendations", () {
    final tId = 1396;

    test("should return data when the call to data source is successful", () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvModelList);

      final result = await repository.getTvSeriesRecommendations(tId);

      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test("should return server failure when the call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId)).thenThrow(ServerException());

      final result = await repository.getTvSeriesRecommendations(tId);

      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure(""))));
    });

    test("should return connection failure when the call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId)).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.getTvSeriesRecommendations(tId);

      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result, equals(Left(ConnectionFailure("Failed to connect to the network"))));
    });
  });

  group("search tv series", () {
    final query = "Breaking Bad";

    test("should return data when call to data source is successful", () async {
      when(mockRemoteDataSource.searchTvSeriesList(query)).thenAnswer((_) async => tTvModelList);

      final result = await repository.searchTvSeriesList(query);

      verify(mockRemoteDataSource.searchTvSeriesList(query));
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test("should return server failure when call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.searchTvSeriesList(query)).thenThrow(ServerException());

      final result = await repository.searchTvSeriesList(query);

      verify(mockRemoteDataSource.searchTvSeriesList(query));
      expect(result, Left(ServerFailure("")));
    });

    test("should return connection failure when call to data source is unsuccessful", () async {
      when(mockRemoteDataSource.searchTvSeriesList(query)).thenThrow(SocketException("Failed to connect to the network"));

      final result = await repository.searchTvSeriesList(query);

      verify(mockRemoteDataSource.searchTvSeriesList(query));
      expect(result, Left(ConnectionFailure("Failed to connect to the network")));
    });
  });

  group("save watchlist tv series", () {
    test("should return success message when saving is successful", () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenAnswer((_) async => "Added to Watchlist");

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Right("Added to Watchlist"));
    });

    test("should return database failure when saving is unsuccessful", () async {
      when(mockLocalDataSource.insertWatchlist(testTvTable))
          .thenThrow(DatabaseException("Failed to add watchlist"));

      final result = await repository.saveWatchlist(testTvDetail);

      expect(result, Left(DatabaseFailure("Failed to add watchlist")));
    });
  });

  group("remove watchlist tv series", () {
    test("should return success message when removing is successful", () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenAnswer((_) async => "Removed from Watchlist");

      final result = await repository.removeWatchlist(testTvDetail);

      verify(mockLocalDataSource.removeWatchlist(testTvTable));
      expect(result, Right("Removed from Watchlist"));
    });

    test("should return database failure when removing is unsuccesful", () async {
      when(mockLocalDataSource.removeWatchlist(testTvTable))
          .thenThrow(DatabaseException("Failed to remove watchlist"));

      final result = await repository.removeWatchlist(testTvDetail);

      verify(mockLocalDataSource.removeWatchlist(testTvTable));
      expect(result, Left(DatabaseFailure("Failed to remove watchlist")));
    });
  });

  group("get watchlist tv series status", () {
    test("should return watch status whether data is found", () async {
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);

      verify(mockLocalDataSource.getTvSeriesById(tId));
      expect(result, false);
    });
  });
  
  group("get watchlist tv series", () {
    test("should return list of tv series", () async {
      when(mockLocalDataSource.getWatchlistTvSeries()).thenAnswer((_) async => [testTvTable]);

      final result = await repository.getWatchlistTvSeries();

      verify(mockLocalDataSource.getWatchlistTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}