import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/data/models/tv/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import '../../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    backdropPath: "/3XjDhPzj7Myr8yzsTO8UB6E2oAu.jpg",
    firstAirDate: "2011-02-28",
    genreIds: [18,80],
    id: 31586,
    name: "La Reina del Sur",
    originCountry: ["US"],
    originalLanguage: "es",
    originalName: "La Reina del Sur",
    overview: "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
    popularity: 2584.928,
    posterPath: "/uBTlJDdPpRxYTfUnKw4wbuIGSEK.jpg",
    voteAverage: 7.8,
    voteCount: 1381
  );

  final tTvResponseModel = TvResponse(tvList: [tTvModel]);

  test("should return a valid tv model from JSON", () async {
    final Map<String, dynamic> jsonMap = json.decode(readJson("dummy_data/airing_today.json"));

    final result = TvResponse.fromJson(jsonMap);

    expect(result, tTvResponseModel);
  });
}