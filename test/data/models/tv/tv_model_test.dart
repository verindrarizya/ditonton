import 'package:ditonton/data/models/tv/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tvModel = TvModel(
    posterPath: "poster",
    popularity: 2.5,
    id: 1,
    backdropPath: "backdrop",
    voteAverage: 2.5,
    overview: "overview",
    firstAirDate: "first",
    originCountry: ["country 1", "country 2"],
    genreIds: [1, 2, 3],
    originalLanguage: "original",
    voteCount: 10,
    name: "name",
    originalName: "originalName"
  );

  final tv = Tv(
    posterPath: "poster",
    popularity: 2.5,
    id: 1,
    backdropPath: "backdrop",
    voteAverage: 2.5,
    overview: "overview",
    firstAirDate: "first",
    originCountry: ["country 1", "country 2"],
    genreIds: [1, 2, 3],
    originalLanguage: "original",
    voteCount: 10,
    name: "name",
    originalName: "originalName"
  );

  test("should be an instance of Tv entity", () {
    final result = tvModel.toEntity();
    expect(result, tv);
  });
}