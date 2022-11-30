import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv/tv_detail_response.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group("get airing today tv series", () {
    final tTvList = TvResponse.fromJson(json.decode(readJson('dummy_data/airing_today.json')))
      .tvList;

    test("should return list of Tv Model when the response code is 200", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/airing_today?$API_KEY")))
          .thenAnswer((_) async => http.Response(readJson('dummy_data/airing_today.json'), 200));

      final result = await dataSource.getTvSeriesAiringToday();

      expect(result, equals(tTvList));
    });

    test("should throw a ServerException when the response is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/airing_today?$API_KEY")))
          .thenAnswer((_) async => http.Response("Not Found", 404,));

      final call = dataSource.getTvSeriesAiringToday();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group("get popular tv series", () {
    final tTvList = TvResponse.fromJson(json.decode(readJson("dummy_data/popular_tv_series.json")))
        .tvList;

    test("should return list of tv series when response is success 200", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/popular?$API_KEY")))
          .thenAnswer((_) async => http.Response(readJson("dummy_data/popular_tv_series.json"), 200));

      final result = await dataSource.getPopularTvSeries();

      expect(result, tTvList);
    });

    test("should throw a ServerException when the response code is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/popular?$API_KEY")))
          .thenAnswer((_) async => http.Response("Not Found", 404));

      final call = dataSource.getPopularTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group("get top rated tv series", () {
    final tTvList = TvResponse.fromJson(json.decode(
      readJson("dummy_data/top_rated_tv_series.json")
    )).tvList;

    test("should return list of tv series when response code is 200", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/top_rated?$API_KEY")))
          .thenAnswer((_) async => http.Response(readJson("dummy_data/top_rated_tv_series.json"), 200)
      );

      final result = await dataSource.getTopRatedTvSeries();

      expect(result, tTvList);
    });

    test("should throw ServerException when response code is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/top_rated?$API_KEY")))
          .thenAnswer((_) async => http.Response("Not Found", 404));

      final call = dataSource.getTopRatedTvSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group("get tv series detail", () {
    final tId = 1;
    final tTvDetail = TvDetailResponse.fromJson(jsonDecode(
      readJson("dummy_data/tv_series_detail.json")
    ));

    test("should return tv series detail when the response code is 200", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/$tId?$API_KEY")))
          .thenAnswer((_) async =>
            http.Response(readJson("dummy_data/tv_series_detail.json"), 200)
      );

      final result = await dataSource.getTvSeriesDetail(tId);

      expect(result, tTvDetail);
    });

    test("should throw ServerException when the response code is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/$tId?$API_KEY")))
          .thenAnswer((_) async =>
            http.Response(readJson("dummy_data/tv_series_detail.json"), 404)
      );

      final call = dataSource.getTvSeriesDetail(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group("get tv series recommendations", () {
    final tId = 1;
    final tTvList = TvResponse.fromJson(jsonDecode(
      readJson("dummy_data/tv_series_recommendations.json")
    )).tvList;

    test("should return list of Tv Model when the response code is 200", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/$tId/recommendations?$API_KEY")))
          .thenAnswer((_ ) async =>
            http.Response(readJson("dummy_data/tv_series_recommendations.json"), 200)
      );

      final result = await dataSource.getTvSeriesRecommendations(tId);

      expect(result, tTvList);
    });

    test("should throw ServerException when the response code is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/tv/$tId/recommendations?$API_KEY")))
          .thenAnswer((_ ) async =>
          http.Response("Not Found", 404)
      );

      final call = dataSource.getTvSeriesRecommendations(tId);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group("search tv series", () {
    final tQuery = "the boys";
    final tSearchResult = TvResponse.fromJson(jsonDecode(
        readJson("dummy_data/search_the_boys_tv_series.json")
    )).tvList;

    test("should return list of tv series when response code is 200", () async {

      print(tSearchResult);
      when(mockHttpClient.get(Uri.parse("$BASE_URL/search/tv?$API_KEY&query=$tQuery")))
        .thenAnswer((_) async => http.Response(
        readJson("dummy_data/search_the_boys_tv_series.json"), 200
      ));

      final result = await dataSource.searchTvSeriesList(tQuery);

      expect(result, tSearchResult);
    });

    test("should throw ServerException when response code is 404 or other", () async {
      when(mockHttpClient.get(Uri.parse("$BASE_URL/search/tv?$API_KEY&query=$tQuery")))
          .thenAnswer((_) async => http.Response(
          "Not Found", 404
      ));

      final call = dataSource.searchTvSeriesList(tQuery);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}